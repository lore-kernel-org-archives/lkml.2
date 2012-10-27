Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2J0QpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:45:05 -0400
Received: from londo.lunn.ch ([80.238.139.98]:57811 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759269Ab2J0QpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:45:04 -0400
Date: Sat, 27 Oct 2012 18:44:48 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mvebu: support for the Globalscale Mirabox MBX0001
 board
Message-ID: <20121027164448.GB15824@lunn.ch>
References: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/arm/boot/dts/mbx001.dts b/arch/arm/boot/dts/mbx001.dts
> new file mode 100644
> index 0000000..88a5a11
> --- /dev/null
> +++ b/arch/arm/boot/dts/mbx001.dts

Hi Gregory

Maybe it would be good to prefix this with armada-370. It then fits
with armada-370-db.dts, and all the kirkwood files are kirkwood-*.dts.

     Andrew
