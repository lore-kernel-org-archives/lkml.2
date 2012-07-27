Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2G0CPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:15:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37997 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2G0CPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <1343353248.2271.8.camel@joe2Laptop>
References: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
	<1343353248.2271.8.camel@joe2Laptop>
Date: Fri, 27 Jul 2012 11:14:59 +0900
Message-ID: <CAOTypNRttRvvpSgmpymuifnmhcmsJ-Bvv2nOMmUCSRV1c81YsQ@mail.gmail.com>
Subject: Re: [PATCH] staging/olpc_dcon: fix checkpatch warnings
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, Jon Nettleton <jon.nettleton@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 10:40 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2012-07-27 at 08:49 +0900, Toshiaki Yamane wrote:
>> Now checkpatch clean.
> []
>> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
> []
>> @@ -11,6 +11,7 @@
> []
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> []
>> @@ -71,18 +72,18 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
>>
>>       ver = dcon_read(dcon, DCON_REG_ID);
>>       if ((ver >> 8) != 0xDC) {
>> -             printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
>> -                     ver);
>> +             pr_err("olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
>> +                    ver);
>>               rc = -ENXIO;
>>               goto err;
>>       }
>>
>>       if (is_init) {
>> -             printk(KERN_INFO "olpc-dcon:  Discovered DCON version %x\n",
>> -                             ver & 0xFF);
>> +             pr_info("olpc-dcon:  Discovered DCON version %x\n",
>> +                     ver & 0xFF);
>
> Hello.
>
> Please remove all the embedded "olpc-dcon: " prefixes.
> There is a pr_fmt define that adds "olpc_dcon" already.
>
> You can use the strings program on the output .o files to
> verify the formats that are produced.
>

Thanks for your reply.

I was able to check for duplicates in strings.
I will try to fix with care.




-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com
