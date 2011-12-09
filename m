Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1LIL2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:28:24 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:26190 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1LIL17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:27:59 -0500
Message-ID: <4EE1F0A6.1090704@oracle.com>
Date: Fri, 09 Dec 2011 19:27:34 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com>	 <1323337048-5426-1-git-send-email-annie.li@oracle.com>	 <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net>	 <4EE08B0D.80504@oracle.com>	 <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net>	 <4EE19A4D.9030500@oracle.com> <4EE1BC7E.3060904@oracle.com> <1323419827.20077.3.camel@zakaz.uk.xensource.com> <291EDFCB1E9E224A99088639C4762022B5988E55CE@LONPMAILBOX01.citrite.net>
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B5988E55CE@LONPMAILBOX01.citrite.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4EE1F0BA.00BF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-12-9 16:48, Paul Durrant wrote:
>> -----Original Message-----
>> From: Ian Campbell
>> Sent: 09 December 2011 08:37
>> To: annie li
>> Cc: Paul Durrant; xen-devel@lists.xensource.com; linux-
>> kernel@vger.kernel.org; konrad.wilk@oracle.com; jeremy@goop.org;
>> kurt.hackel@oracle.com
>> Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
>>
>> On Fri, 2011-12-09 at 07:45 +0000, annie li wrote:
>>     
>>> On 2011-12-9 13:19, annie li wrote:
>>>       
>>>> Hi Paul,
>>>>
>>>>         
>>>>>>> #define get_free_entry()    get_free_entries(1)
>>>>>>>               
>>>> Is this necessary? Maybe you defined this to keep consistence
>>>>         
>> with
>>     
>>>> put_free_entry(ref)?
>>>> But other functions such as gnttab_grant_foreign_transfer and
>>>> gnttab_grant_foreign_access all call get_free_entries(1). Maybe
>>>>         
>> it
>>     
>>>> is better to keep initial get_free_entries(1) code?
>>>>         
>>> Another approach is doing those work in a separate patch --
>>>       
>> changing
>>     
>>> get_free_entries to get_free_entry in following 4 functions:
>>>       
>> I think you shouldn't get too bogged down in get_free_entry() vs
>> get_free_entries(1) for the purposes of this patch series.
>>
>>     
>
> Annie,
>
>   Yes, don't worry about get_free_entry(). I only defined it for the sake of symmetry in the code I posted.
>   
OK, will keep get_free_entries(1) unchanged.

Thanks
Annie
>   Paul
>   
