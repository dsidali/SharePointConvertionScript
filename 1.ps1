#Install-Module -Name PnP.PowerShell

#Add-PnPStoredCredential -Name "https://8fcz4z.sharepoint.com" -Username sidali@8fcz4z.onmicrosoft.com -Password (ConvertTo-SecureString -String "Informatik.1" -AsPlainText -Force)




function Convert{
    param (
        $SiteURL
    )

 Connect-PnPOnline $SiteURL -Interactive
 
#Get All Pages from "Site Pages" Library
$Pages = Get-PnPListItem -List SitePages -PageSize 500
 
Try {
    ForEach($Page in $Pages)
    {
        #Get the page name
        $PageName = $Page.FieldValues.FileLeafRef
        Write-host "Converting Page:"$PageName
 
        #Check if the page is classic
        If($Page.FieldValues["ClientSideApplicationId"] -eq "b6917cb1-93a0-4b97-a84d-7cf49975d4ec")
        {
            Write-host "`tPage is already Modern:"$PageName -f Yellow
        }
        Else
        {
            #Conver the classic page to modern page
            ConvertTo-PnPPage -Identity $PageName -Overwrite -TakeSourcePageName -AddPageAcceptBanner
            Write-host "`tPage Converted to Modern!" -f Green    
        }
    }
}
Catch {
    write-host -f Red "Error Converting Clasic Page to Modern!" $_.Exception.Message
}


}








connect-pnponline -url https://8fcz4z-admin.sharepoint.com -Interactive 

$AllSites = Get-PnPTenantSite

#Connect-PnPOnline -url $AllSites[3].Url -Interactive

ForEach($CurrentSite in $AllSites){
Connect-PnPOnline  $CurrentSite.Url  -Interactive

Convert -SiteURL $CurrentSite.Url

 $SubSites = Get-PnPSubWeb

 foreach ($SubSite in $SubSites){
 Connect-PnPOnline  $SubSite.Url  -Interactive

Convert -SiteURL $SubSite.Url
 }
 }







 ################################################################################################
#Set Parameters
#$SiteURL="https://8fcz4z.sharepoint.com/sites/classico"
 
#Connect to Site

<#
Connect-PnPOnline $SiteURL -Interactive
 
#Get All Pages from "Site Pages" Library
$Pages = Get-PnPListItem -List SitePages -PageSize 500
 
Try {
    ForEach($Page in $Pages)
    {
        #Get the page name
        $PageName = $Page.FieldValues.FileLeafRef
        Write-host "Converting Page:"$PageName
 
        #Check if the page is classic
        If($Page.FieldValues["ClientSideApplicationId"] -eq "b6917cb1-93a0-4b97-a84d-7cf49975d4ec")
        {
            Write-host "`tPage is already Modern:"$PageName -f Yellow
        }
        Else
        {
            #Conver the classic page to modern page
            ConvertTo-PnPPage -Identity $PageName -Overwrite -TakeSourcePageName -AddPageAcceptBanner
            Write-host "`tPage Converted to Modern!" -f Green    
        }
    }
}
Catch {
    write-host -f Red "Error Converting Clasic Page to Modern!" $_.Exception.Message
}


#Read more: https://www.sharepointdiary.com/2019/04/sharepoint-online-convert-classic-page-to-modern-using-powershell.html#ixzz7vXwzRpVp

#>