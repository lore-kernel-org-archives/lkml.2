Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2KXHCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 02:02:53 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:38046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2KXHCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 02:02:52 -0500
Date: Sat, 24 Nov 2012 08:02:40 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: Dove: Convert to DT GPIO and pinctrl
Message-ID: <20121124080240.3f600e89@skate>
In-Reply-To: <20121124023942.GO15800@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1353317996-20841-4-git-send-email-sebastian.hesselbarth@gmail.com>
	<20121124023942.GO15800@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Fri, 23 Nov 2012 21:39:42 -0500, Jason Cooper wrote:
> > +		pinctrl: pinctrl@d0200 {
> > +			compatible = "marvell,dove-pinctrl";
> > +			reg = <0xd0200 0x10>;
> > +			clocks = <&gate_clk 22>;
> 
> The above line broke the dtbs build target for dove_defconfig.  I have
> removed it.  Please let me know if that is not the correct answer.  This
> was the only occurence of 'clk' in arch/arm/boot/dts/dove* .

Are you sure you merged

 [PATCH 7/8] ARM: dove: switch to DT clock providers ?

This one clearly adds gate_clk in dove.dtsi. This patch was part of the
pull request:

Subject: [GIT PULL v3] core, cpu and gated clocks for mvebu
Date: Tue, 20 Nov 2012 15:31:08 +0100

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
