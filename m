Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab1GDQdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:33:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33209 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab1GDQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:33:16 -0400
Date: Mon, 4 Jul 2011 10:33:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH v2 2/2] gpio: Add a driver for Sodaville GPIO controller
Message-ID: <20110704163313.GB28042@ponder.secretlab.ca>
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
 <1309159583-11339-2-git-send-email-bigeasy@linutronix.de>
 <20110704161914.GH29977@ponder.secretlab.ca>
 <4E11EA63.8010909@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E11EA63.8010909@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 06:29:23PM +0200, Sebastian Andrzej Siewior wrote:
> Grant Likely wrote:
> >
> >I tried to apply this, but it failed to build:
> >
> >/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: In
> >function ‘sdv_xlate’:
> >/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:106:15:
> >error: ‘struct irq_domain’ has no member named ‘of_node’
> 
> >I assume there is a missing #include, you can either send a fixup
> >patch or a new version, your choice.
> 
> I guess you have to ask the DT maintainer which merged the irq_domain
> thingy to create a topic branch for you :)

HAHAHA.  I didn't bother to go digging into why it didn't compile.
I'll merge the branches and see how it goes.

> 
> >Also...
> >
> >>diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> >>index 0fbdd75..cc6d662 100644
> >>--- a/drivers/gpio/Makefile
> >>+++ b/drivers/gpio/Makefile
> >>@@ -41,6 +41,7 @@ obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
> >> obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
> >> obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
> >>+obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
> >> obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
> >> obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
> >> obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
> >
> >Last I checked, SO comes before ST in alphabetized lists.  :-)
> 
> Ah, we use the standardized one. Is it okay to send an incremental patch
> for that once it compiles?

Don't worry about it.  I've already fixed it up.

g.

