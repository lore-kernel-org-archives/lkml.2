Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab2ILQCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:02:31 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:46324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab2ILQC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:02:29 -0400
Date: Wed, 12 Sep 2012 18:01:54 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] pinctrl: mvebu: pinctrl driver core
Message-ID: <20120912180154.3e620d18@skate>
In-Reply-To: <CACRpkdYVMTbfA++eqRrq6JM0phjN-X-f3N==oXbyVxCyYUVOOA@mail.gmail.com>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<20120911164409.4c030bd8@skate>
	<504FB869.60201@wwwdotorg.org>
	<20120912085423.21af58d5@skate>
	<CACRpkdYVMTbfA++eqRrq6JM0phjN-X-f3N==oXbyVxCyYUVOOA@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 12 Sep 2012 17:50:48 +0200,
Linus Walleij <linus.walleij@linaro.org> a écrit :

> This is a valid reason to keep it as is in my book.
> Readability along with a datasheet is important, most important
> is that it has a good structure for those maintaining the driver.
> 
> Is this datasheet available so I can get the picture?

All publicly available datasheets for Marvell ARM SoCs are referenced
in Documentation/arm/Marvell/README.

See for example
http://www.marvell.com/embedded-processors/kirkwood/assets/HW_88F6281_OpenSource.pdf,
which is the hardware datasheet for the 88F6281 Marvell SoC (Kirkwood
family). Table 26 on page 53 of the PDF is a good example. It lists all
the pins, on per row, and then has columns for each function identifier
(from 0x0 to 0x7). Then each cell says when pin X is muxed in function
Y, it provides this functionality.

So clearly, this representation is a list of pins, and for each pin, a
list of possible functions that this pin can take.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
