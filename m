Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2HTSwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:52:17 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:52994 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2HTSwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:52:15 -0400
Date: Mon, 20 Aug 2012 20:51:59 +0200
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
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 04/11] pinctrl: mvebu: add pinctrl driver for Armada 370
Message-ID: <20120820205159.63001848@skate>
In-Reply-To: <50327B8F.3050503@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-5-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdYNZar7865-T12J37h3AWA9-8R1R5tymuOhaB0b3ddEAA@mail.gmail.com>
	<50326A60.1070007@gmail.com>
	<20120820193622.4e539451@skate>
	<50327B8F.3050503@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 20 Aug 2012 20:01:51 +0200,
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :

> > If that's fine with you, then I would prefer if we keep the single
> > MACH_ARMADA_370_XP symbol for now, so that your pinctrl set of
> > patches does not depend on something else. We would do the small
> > Kconfig option refactoring as a follow-up set of patches. Thoughts?
> 
> Despite any objections, I will remove all arch/arm/*/Kconfig patches
> from pinctrl patch set.

Ok, fine with me, but we'll have to send separate patches for those,
then.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
