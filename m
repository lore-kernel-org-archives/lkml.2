Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0FHLPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:15:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57687 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0FHLPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kKDy3XoDstuI26s9Shjf41aYV8gsLKQponZIKXDINtwzMGiEV3BBbb6b770EhxPdPt
         iQSJb+8Uv+OitmQTK6K889NC0uW1yk0nPLrCUjrdQf02D9osBkNLdQEK1I8IQmsJm+Uo
         MEV2Jr/mLEBhbw8HKhHBOcBcB8/cSJjyNCZKM=
MIME-Version: 1.0
In-Reply-To: <20100608092458.GA5483@bicker>
References: <AANLkTik9UM9ta3r7ZNt8Z-CNS6Vz-aIWb_qewgECFfoe@mail.gmail.com>
	<20100608092458.GA5483@bicker>
Date: Tue, 8 Jun 2010 07:15:34 -0400
Message-ID: <AANLkTikNN8A0X2z8TL0MPHqjXrS-4uqrkVcoV_dqxeiv@mail.gmail.com>
Subject: Re: [PATCH] Documentation/filesystems/xip.txt: clarify the statement: 
	The block device option is mandatory for execute-in-place
From: shenghui <crosslonelyover@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, cotte@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/8 Dan Carpenter <error27@gmail.com>:
> On Tue, Jun 08, 2010 at 04:37:04PM +0800, shenghui wrote:
>> diff --git a/Documentation/filesystems/xip.txt
>> b/Documentation/filesystems/xip.txt
>> index 0466ee5..bef4120 100644
>> --- a/Documentation/filesystems/xip.txt
>> +++ b/Documentation/filesystems/xip.txt
>> @@ -35,8 +35,7 @@ is performed. A struct block_device reference is
>> used to address the device,
>
> I don't know about xip, but the patch is malformed.  It's line wrapped
> here.
>
>>  and a sector_t argument is used to identify the individual block. As an
>>  alternative, memory technology devices can be used for this.
>>
>> -The block device operation is optional, these block devices support it as of
>> -today:
>> +The block device operation is mandatory for execute-in-place, these
>> block devices support it as of today:
>
> And here.
>
>>  - dcssblk: s390 dcss block device driver
>>
>
> There is documentation in Documentation/email-clients.txt.  Send a patch
> to yourself, then save it as a raw document.
>
> cd path/to/linux
> cat raw-email | patch -p1
>
> If it applies correctly resend your patch to the list.
>
> regards,
> dan carpenter
>
>
>

Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 Documentation/filesystems/xip.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/xip.txt
b/Documentation/filesystems/xip.txt
index 0466ee5..caaa8b4 100644
--- a/Documentation/filesystems/xip.txt
+++ b/Documentation/filesystems/xip.txt
@@ -35,8 +35,8 @@ is performed. A struct block_device reference is
used to address the device,
 and a sector_t argument is used to identify the individual block. As an
 alternative, memory technology devices can be used for this.

-The block device operation is optional, these block devices support it as of
-today:
+The block device operation is mandatory for execute-in-place, these block
+devices support it as of today:
 - dcssblk: s390 dcss block device driver

 An address space operation named get_xip_mem is used to retrieve references
-- 
1.7.0.1


-- 


Thanks and Best Regards,
shenghui
