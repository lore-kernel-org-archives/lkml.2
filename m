Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab2CEU5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:57:55 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51203 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab2CEU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:57:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.44.68 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <4F54FBBC.5060809@xenotime.net>
References: <20120305181024.d396adb4fefdf6d269657606@canb.auug.org.au> <4F54FBBC.5060809@xenotime.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Mar 2012 13:57:33 -0700
X-Google-Sender-Auth: e-gLqTS3CwereFnxzzLhyItXfVA
Message-ID: <CACxGe6vPnFcUQ0mNF4CU5LLLJj=F5A2=1m8u=v1KJDHZnXS4Tw@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 5 (of/irqs)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 10:45 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 03/04/2012 11:10 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120302:
>
>
>
> Still have both of these build errors (on i386/X86_32;
> 2 different builds):
>
>
> drivers/mfd/twl-core.c:1262:2: error: implicit declaration of function 'irq_alloc_descs'
> drivers/mfd/twl-core.c:1357:3: error: implicit declaration of function 'of_platform_populate'

The fix didn't get pushed out until I received an ack from Benoit this
morning.  It will be fixed in tomorrow's linux-next.

> and:
>
> drivers/gpio/gpio-sodaville.c:130:2: error: unknown field 'dt_translate' specified in initializer
> drivers/gpio/gpio-sodaville.c:130:2: warning: initialization from incompatible pointer type
> drivers/gpio/gpio-sodaville.c:152:8: error: 'struct irq_domain' has no member named 'irq_base'
> drivers/gpio/gpio-sodaville.c:182:2: error: implicit declaration of function 'irq_domain_add'
> drivers/gpio/gpio-sodaville.c:263:2: error: implicit declaration of function 'irq_domain_del'

I don't have the fix ready yet.  It is coming.

g.
