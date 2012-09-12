Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2ILG5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:57:09 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:39920 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2ILG5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:57:06 -0400
Date: Wed, 12 Sep 2012 08:56:52 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 6/9] ARM: mvebu: add pinctrl device in DT for Armada
 370/XP SoCs
Message-ID: <20120912085652.21d3232f@skate>
In-Reply-To: <504FB9D7.3030205@wwwdotorg.org>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-7-git-send-email-sebastian.hesselbarth@gmail.com>
	<504FB9D7.3030205@wwwdotorg.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 11 Sep 2012 16:23:19 -0600,
Stephen Warren <swarren@wwwdotorg.org> a écrit :

> On 09/10/2012 02:39 AM, Sebastian Hesselbarth wrote:
> > From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > 
> > The Armada 370 and XP SoCs have configurable muxing for a certain
> > number of their pins, controlled through a pinctrl driver.
> 
> Hmmm. I'd be tempted just to put the entire node definition there;
> putting in a .dtsi file just to share the reg property doesn't seem
> especially useful.

When you say "here" you're mentioning the SoC-specific .dtsi files (i.e
the ones in PATCH 7/9 and PATCH 8/9), correct?

> > The 'compatible' property is defined in the SoC-specific .dtsi files,
> > since the compatible string identifies the number of pins and other
> > SoC-specific properties.
> 
> > diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
> 
> > +		pinctrl@d0018000 {
> 
> If this is the only pinctrl instance, you'd typically name the node just
> "pinctrl", since the "@d0018000" isn't needed to get unique node names.

Ack.

> > +			reg = <0xd0018000 0x38>;
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			ranges;
> 
> What is "ranges" for; this isn't a memory-mapped bus, right?

Ack.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
