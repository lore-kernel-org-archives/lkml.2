Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2G0FFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 01:05:51 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45126 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2G0FFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 01:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <1343365419.2040.14.camel@joe2Laptop>
References: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
	<1343364390-11410-1-git-send-email-yamanetoshi@gmail.com>
	<1343365419.2040.14.camel@joe2Laptop>
Date: Fri, 27 Jul 2012 14:05:49 +0900
Message-ID: <CAOTypNSE44S9ws_wna9n=KOkCXmt=3Cysw7sNrMT+LBgAyr4Zg@mail.gmail.com>
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

On Fri, Jul 27, 2012 at 2:03 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2012-07-27 at 13:46 +0900, Toshiaki Yamane wrote:
>> fixed some checkpatch warnings.
>> (Excluding -WARNING: msleep < 20ms can sleep for up to 20ms-)
> []
>> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
> []
>> @@ -71,18 +72,18 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
>>
>>       ver = dcon_read(dcon, DCON_REG_ID);
>>       if ((ver >> 8) != 0xDC) {
>> -             printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
>> -                     ver);
>> +             pr_err("DCON ID not 0xDCxx: 0x%04x instead.\n",
>> +                    ver);
>
> Please fit arguments on a single line where feasible.

I agree.
