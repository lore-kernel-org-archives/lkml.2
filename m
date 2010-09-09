Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab0IIWu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:50:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0IIWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q5TPYCK3R48HE+cRfP++MReOZiJaxuC3Ola1RZhEYN4NojWxfIEVdswHWcudLRFmXX
         2oBFPqmd4WcNl6JHJ2iPYJ02MKjxWf7NS3HG8f9oBpzLbkD4Wy2ARKRA/ZGOfgvxhgxI
         hKRbMekVUZrZHFgNWmPz0NIi2JOunuD5fvgxI=
Message-ID: <4C8964D3.1000901@gmail.com>
Date: Thu, 09 Sep 2010 15:50:59 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 129/223]drivers/scsi/Kconfig Update broken web addresses.
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com> <1284071862-8194-9-git-send-email-justinmattock@gmail.com> <20100909154213.aefda094.rdunlap@xenotime.net>
In-Reply-To: <20100909154213.aefda094.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 03:42 PM, Randy Dunlap wrote:
> On Thu,  9 Sep 2010 15:37:36 -0700 Justin P. Mattock wrote:
>
>> Below you will find an Update to a broken web address.
>> Please let me know if this needs to be changed.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/scsi/Kconfig |   14 +++++++-------
>>   1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index bbf91ae..6fe68d0 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1608,9 +1608,9 @@ config SCSI_DEBUG
>>   	  each with multiple dummy SCSI devices (disks). It defaults to one
>>   	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
>>   	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
>> -	  dummy disks are simulated, they share the same kernel RAM for
>> -	  their storage. See<http://www.torque.net/sg/sdebug.html>  for more
>> -	  information. This driver is primarily of use to those testing the
>> +	  dummy disks are simulated, they share the same kernel RAM for their
>> +	  storage. See<http://web.archive.org/web/*/http://www.torque.net/sg/sdebug.html>
>> +	  for more information. This driver is primarily of use to those testing the
>>   	  SCSI and block subsystems. If unsure, say N.
>
> This one should be<http://sg.danny.cz/sg/sdebug26.html>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>


cool, thanks..

Justin P. Mattock
