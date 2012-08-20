Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2HTRh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:37:58 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:52423 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2HTRh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:37:56 -0400
Date: Mon, 20 Aug 2012 19:37:34 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/11] arm: mvebu: add pinctrl support in defconfig
Message-ID: <20120820193734.4fcdbb1a@skate>
In-Reply-To: <50324FA3.9030005@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-12-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdaF3OuBLC7odWyH5C_EJT9uFq1rYQMh6=kr8PQjvA68sA@mail.gmail.com>
	<50324FA3.9030005@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 20 Aug 2012 16:54:27 +0200,
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :

> On 08/20/2012 04:31 PM, Linus Walleij wrote:
> > On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
> > <sebastian.hesselbarth@gmail.com>  wrote:
> >> +CONFIG_PINCTRL_ARMADA_370=y
> >> +CONFIG_PINCTRL_ARMADA_XP=y
> >
> > If the system is not even booting without pinctrl you should
> > (IMHO) select these from the machine's Kconfig entry insteaf.
> 
> I don't have a strong opinion on this but I think most systems
> will boot just fine without pinctrl. The basic stuff is set up
> by u-boot. Anyway, I think we should enable pinctrl for each soc
> by default.

Yes, the system boots fine without the pinctrl support. So I don't
think that MACH_ARMADA_370_XP should forcefully select the pinctrl
code, but it's nice to have the default defconfig for this platform
select the pinctrl support.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
