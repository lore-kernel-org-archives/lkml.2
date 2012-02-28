Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2B1AHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:07:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50944 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755068Ab2B1AHN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:07:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.202.69 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120228104047.85b5515f3b27c631580f5503@canb.auug.org.au>
References: <20120227182029.545a7db32550ce94c9faffb4@canb.auug.org.au>
 <4F4BC3C5.8040802@xenotime.net> <20120228104047.85b5515f3b27c631580f5503@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 Feb 2012 17:06:53 -0700
X-Google-Sender-Auth: VdKv3JkhHMFc1eerwp18FbkM_iw
Message-ID: <CACxGe6sFTSu8eznKDecjTj+2fyBXN4_+EM2SaQRSZMmFyonD4w@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 27 (gpio-sodaville.c)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 4:40 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Mon, 27 Feb 2012 09:56:21 -0800 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> on i386:
>>
>> drivers/gpio/gpio-sodaville.c:130:2: error: unknown field 'dt_translate' specified in initializer
>> drivers/gpio/gpio-sodaville.c:130:2: warning: initialization from incompatible pointer type
>> drivers/gpio/gpio-sodaville.c: In function 'sdv_register_irqsupport':
>> drivers/gpio/gpio-sodaville.c:152:8: error: 'struct irq_domain' has no member named 'irq_base'
>> drivers/gpio/gpio-sodaville.c:182:2: error: implicit declaration of function 'irq_domain_add'
>> drivers/gpio/gpio-sodaville.c: In function 'sdv_gpio_remove':
>> drivers/gpio/gpio-sodaville.c:263:2: error: implicit declaration of function 'irq_domain_del'
>
> These are a conflicts between the gio tree and the irqdomain tree.
> Grant, can you supply me with a merge fix patch?  Or will you merge the
> irqdomain stuff into the gpio tree (making sure that the irqdomain tree
> never rebases again) ...

The irqdomain branch has already been made stable for that exact
reason with other trees.  I'll get it fixed up and send out an update.
 I've got 4 hours on a plane tomorrow, so I'll probably crank it out
then.

g.
