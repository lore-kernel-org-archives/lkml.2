Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab2J0Qyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:54:37 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:56875 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2J0Qyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:54:36 -0400
Date: Sat, 27 Oct 2012 18:54:25 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mvebu: support for the Globalscale Mirabox MBX0001
 board
Message-ID: <20121027185425.40cabf8b@skate>
In-Reply-To: <20121027164448.GB15824@lunn.ch>
References: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
	<20121027164448.GB15824@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Oct 2012 18:44:48 +0200, Andrew Lunn wrote:
> > diff --git a/arch/arm/boot/dts/mbx001.dts b/arch/arm/boot/dts/mbx001.dts
> > new file mode 100644
> > index 0000000..88a5a11
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/mbx001.dts
> 
> Hi Gregory
> 
> Maybe it would be good to prefix this with armada-370. It then fits
> with armada-370-db.dts, and all the kirkwood files are kirkwood-*.dts.

So for OpenBlocks, I should rename armada-xp-openblocks-ax3-4.dts as
well, I guess. I agree with your comment: I think that a name such as
mbx001.dts is way too generic.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
