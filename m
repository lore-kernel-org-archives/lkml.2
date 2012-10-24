Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439Ab2JXHl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:41:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35655 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401Ab2JXHlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <021101cdb128$1f56c1c0$5e044540$%kim@samsung.com>
References: <002801cdac0a$11e4f340$35aed9c0$%han@samsung.com>
	<CACRpkdYx1HLF2==6DsPp+qC6Xyb7Ag8qa1K7g2Ht-Y2T-UjzMA@mail.gmail.com>
	<00a201cdaff0$d90a11a0$8b1e34e0$%han@samsung.com>
	<CACRpkdZCH_bxviyz5Qqx0ttFFGW-CkJT6vCT3-JcOgQ5quK0kg@mail.gmail.com>
	<021101cdb128$1f56c1c0$5e044540$%kim@samsung.com>
Date: Wed, 24 Oct 2012 09:41:23 +0200
Message-ID: <CACRpkdYKXZwFLhnw0AAcjELqUnRG+xzahtwgvQvAUQEFevPWXw@mail.gmail.com>
Subject: Re: [PATCH V3] gpio: samsung: use pr_* instead of printk
From: Linus Walleij <linus.walleij@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Mallon <rmallon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 4:10 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Linus Walleij wrote:
>>
>> On Mon, Oct 22, 2012 at 3:02 AM, Jingoo Han <jg1.han@samsung.com> wrote:
>> > On Friday, October 19, 2012 7:09 PM Linus Walleij wrote
>> >>
>> >> On Wed, Oct 17, 2012 at 3:52 AM, Jingoo Han <jg1.han@samsung.com>
> wrote:
>> >>
>> >> > This patch uses pr_* instead of printk. Also, gpio_dbg
>> >> > is replaced with pr_debug.
>> >> >
>> >> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>> >> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org> <- NAK
>> >>
>> >> Please consult Documentation/SubmittingPatches as to the conditions
>> that
>> >> apply when you add Reviewed-by tags.
>> >
>> > Um, you already gave the Reviewed-by to the same patch, a month ago.
>> > Anyway, I will remove Reviewed-by and send v4 patch, soon.
>>
>> My bad. I confused this mail thread for something else, sorry
>> for this. :-(
>>
>> Please keep the Reviewed-tag if you want to!
>>
> Linus, if you don't have any objection, let me take this into Samsung tree.

Of course you should take it, sorry for the mess.
Acked-by/Reviewed-by: <linus.walleij@linaro.org>

Yours,
Linus Walleij
