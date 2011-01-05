Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1AEF3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:29:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35199 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1AEF27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:28:59 -0500
Message-ID: <4D24017A.3060202@oracle.com>
Date: Wed, 05 Jan 2011 13:28:26 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: declare MODULE_FIRMWARE in libsas
References: <4D22CF9F.1070005@oracle.com> <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org> <4D23E315.9060900@oracle.com> <20110105044733.GA6256@cr0.nay.redhat.com>
In-Reply-To: <20110105044733.GA6256@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang 写道:
> On Wed, Jan 05, 2011 at 11:18:45AM +0800, DuanZhenzhong wrote:
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
>> I was finding all requested but not exported firmware in scsi driver
>> for generating dump initrd use.
>> In sas_scsi_host.c, request_firmware is called with "sas_addr",
>> sas_addr neither builtin nor exported. Don't sas_addr a firmware?
>> Please correct me. thanks
>>
>>     
>
> But once you export it, it needs to be found in fireware/ directory...
>   
Not exactly, firmware/ dir only have a subset of all needed firmware. 
Also one can load firmware manually from anywhere

-- 
Regards
zhenzhong

