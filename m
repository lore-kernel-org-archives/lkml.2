Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1IBH5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:57:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57335 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab1IBH53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAOY=C6F7x+8UJv+0wChch4SAiRd+PRVgdCbZQ1_Db21uc-_9Bw@mail.gmail.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<CAOY=C6F7x+8UJv+0wChch4SAiRd+PRVgdCbZQ1_Db21uc-_9Bw@mail.gmail.com>
Date: Fri, 2 Sep 2011 09:57:28 +0200
Message-ID: <CACRpkdZy0LokSNmzb-9FnAkc-61gp+_G07JuTxTEssqSUjtcVg@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 9:02 AM, Stijn Devriendt <highguy@gmail.com> wrote:
> On Fri, Aug 19, 2011 at 11:53 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:

>> +       if (desc->mux_requested) {
>> +               pr_err("pin already requested\n");
>> +               goto out;
>> +       }
>
> Isn't locking missing here?

You're right, I have now introduced a spinlock to the pin descriptor
and take that before reading or writing descriptor fields like this.

Thanks!
Linus Walleij
