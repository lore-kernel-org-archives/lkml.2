Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2LRQ7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:59:45 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:40902 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270Ab2LRQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:59:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/YuB6Gj5B3qZF1Dtytanf1
Date: Tue, 18 Dec 2012 08:59:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Loic Pallardy <loic.pallardy-ext@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: Re: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
Message-ID: <20121218165909.GF4989@atomide.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1355836212-17956-2-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355836212-17956-2-git-send-email-loic.pallardy-ext@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Loic Pallardy <loic.pallardy-ext@stericsson.com> [121218 05:15]:
> Actually moving it from plat-omap, as this framework/driver code is
> supposed to be under drivers/ folder. The framework should work with
> the current supported OMAP processors (OMAP1+) that have mailbox and
> can be used as a method of interprocessor communication.
> 
> The mailbox hardware (in OMAP) uses a queued mailbox-interrupt mechanism
> that provides a communication channel between processors through a set of
> registers and their associated interrupt signals by sending and receiving
> messages.
> 
> As part of the migration from plat and mach code:
> - Kconfig symbols have been renamed to build OMAP1 or OMAP2+ drivers.
> - mailbox.h has been changed from plat to a dedicated drivers/ folder.
> - soc.h has been changed for plat/cpu.h, since there are dependencies in
>   the cpu_is_XXXX() macro.
> 
> Module names have changed too, instead of mailbox_mach:
> - OMAP1: mailbox-omap1.ko
> - OMAP2+: mailbox-omap2.ko
> 
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

AFAIK the first two patches should have:
From: Omar Ramirez Luna <omar.luna@linaro.org>

Once that's fixed, for arch/arm/*omap*/* parts:

Acked-by: Tony Lindgren <tony@atomide.com>
