Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1AEF1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:27:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34387 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1AEF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:27:07 -0500
Message-ID: <4D240129.5080200@oracle.com>
Date: Wed, 05 Jan 2011 13:27:05 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: declare MODULE_FIRMWARE in libsas
References: <4D22CF9F.1070005@oracle.com>	 <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org>	 <4D23E315.9060900@oracle.com> <1294202192.7879.30.camel@mulgrave.site>
In-Reply-To: <1294202192.7879.30.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley 写道:
> On Wed, 2011-01-05 at 11:18 +0800, DuanZhenzhong wrote:
>   
>> Jeff Garzik 写道:
>>     
>>> On 01/04/2011 09:08 AM, James Bottomley wrote:
>>>       
>>>> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>>>         
>>>>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>>>
>>>>> ---
>>>>>           
>>>> Description?  Since libsas has no firmware, surely some explanation is
>>>> required.
>>>>         
>>> Indeed.  Looks bogus at first glance?
>>>
>>>
>>>       
>> I was finding all requested but not exported firmware in scsi driver for 
>> generating dump initrd use.
>> In sas_scsi_host.c, request_firmware is called with "sas_addr", sas_addr 
>> neither builtin nor exported. Don't sas_addr a firmware? Please correct 
>> me. thanks
>>     
>
> No, it's not requesting any firmware ... it's a slight misuse of the
> firmware mechanism that allows a libsas based driver to be given a SAS
> address if it doesn't have an internal nsvram to store one.
>
> James
>
>
>   
I see, thanks

-- 
Regards
zhenzhong

