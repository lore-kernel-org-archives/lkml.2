Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab0DJSIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 14:08:50 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:48376 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DJSIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 14:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JN4uFQVaVA6ogjDfcr3cLYOnUdDLuBcmfqHzBpqX7W5BuswBnUJGLR1lVJpOEl4XE4
         qKDvgQTrS6tlY2zlwPnGUYD7B0u/On4kCrnaBKRWBqf4OC0R0VTUA1dngBYPt9IN94tC
         caKBFjgJC+Eos4A0lXHdrPFx4fdmkzp/y/Peg=
MIME-Version: 1.0
In-Reply-To: <20100315053258.GB11552@elf.ucw.cz>
References: <1268624694-11635-1-git-send-email-chihau@gmail.com>
	 <20100315053258.GB11552@elf.ucw.cz>
Date: Sat, 10 Apr 2010 14:08:47 -0400
Message-ID: <z2lf5ca57691004101108refe9adf4y7067be0460817840@mail.gmail.com>
Subject: Re: [PATCH] Staging: dream: smd: smd_qmi: fix code style issues
From: Chihau Chau <chihau@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, What about this patch? Greg?

2010/3/15 Pavel Machek <pavel@ucw.cz>:
> On Mon 2010-03-15 00:44:54, Chihau Chau wrote:
>> From: Chihau Chau <chihau@gmail.com>
>>
>> This fixes some code style issues about to #include <linux/uaccess.h>
>> instead of <asm/uaccess.h> and some not necessary braces {}.
>>
>> Signed-off-by: Chihau Chau <chihau@gmail.com>
>
> ACK.
>
>> ---
>>  drivers/staging/dream/smd/smd_qmi.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/dream/smd/smd_qmi.c b/drivers/staging/dream/smd/smd_qmi.c
>> index 687db14..9e9067f 100644
>> --- a/drivers/staging/dream/smd/smd_qmi.c
>> +++ b/drivers/staging/dream/smd/smd_qmi.c
>> @@ -25,7 +25,7 @@
>>  #include <linux/miscdevice.h>
>>  #include <linux/workqueue.h>
>>
>> -#include <asm/uaccess.h>
>> +#include <linux/uaccess.h>
>>  #include <mach/msm_smd.h>
>>
>>  #define QMI_CTL 0x00
>> @@ -643,11 +643,10 @@ static int qmi_print_state(struct qmi_ctxt *ctxt, char *buf, int max)
>>       }
>>
>>       i = scnprintf(buf, max, "STATE=%s\n", statename);
>> -     i += scnprintf(buf + i, max - i, "CID=%d\n",ctxt->wds_client_id);
>> +     i += scnprintf(buf + i, max - i, "CID=%d\n", ctxt->wds_client_id);
>>
>> -     if (ctxt->state != STATE_ONLINE){
>> +     if (ctxt->state != STATE_ONLINE)
>>               return i;
>> -     }
>>
>>       i += scnprintf(buf + i, max - i, "ADDR=%d.%d.%d.%d\n",
>>               ctxt->addr[0], ctxt->addr[1], ctxt->addr[2], ctxt->addr[3]);
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Chihau Chau
