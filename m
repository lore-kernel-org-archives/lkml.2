Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab2J0RRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:17:43 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:57066 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab2J0RRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:17:42 -0400
Date: Sat, 27 Oct 2012 19:17:23 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mvebu: support for the Globalscale Mirabox MBX0001
 board
Message-ID: <20121027191723.23a691a2@skate>
In-Reply-To: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
References: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Oct 2012 18:22:45 +0200, Gregory CLEMENT wrote:
> This platform, available from Globalscale has an Armada 370. For now,
> only the serial port is supported. Support for network, USB and other
> peripherals will be added as drivers for them become available for
> Armada 370 in mainline.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile          |    3 ++-
>  arch/arm/boot/dts/mbx001.dts        |   37 +++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mvebu/armada-370-xp.c |    1 +
>  3 files changed, 40 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/mbx001.dts

With the rename mbx001.dts -> mbx0001.dts, this works fine for me on
the hardware platform, so:

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
