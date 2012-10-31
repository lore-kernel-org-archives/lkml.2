Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2JaHcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:32:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59964 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2JaHcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:32:18 -0400
Date: Wed, 31 Oct 2012 08:32:16 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Philippe Reynes <tremyfr@yahoo.fr>
Cc: "eric.jarrige@armadeus.org" <eric.jarrige@armadeus.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "julien.boibessot@armadeus.com" <julien.boibessot@armadeus.com>
Subject: Re: [PATCH] Add device tree file for the armadeus apf27
Message-ID: <20121031073216.GI1641@pengutronix.de>
References: <1351268980-25347-1-git-send-email-tremyfr@yahoo.fr>
 <20121029211015.GX1641@pengutronix.de>
 <1351626944.55016.YahooMailNeo@web28804.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351626944.55016.YahooMailNeo@web28804.mail.ir2.yahoo.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:24:20 up 129 days, 11:35, 20 users,  load average: 0.20, 0.30,
 0.36
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 07:55:44PM +0000, Philippe Reynes wrote:
> 
> 
> Hi Sascha,
> >> +        osc26m {
> 
> >> +            compatible = "fsl,imx-osc26m", "fixed-clock";
> >> +            clock-frequency = <33554432>;
> 
> >Is this really correct? The Datasheet specificies 26MHz, some boards
> >have 27Mhz, but 33?
> 
> The clock value on this board is  32.768kHz, so 32768 * 1024.
> I've tried others value, all others produce weird behaviour on the serial.

Ok, so your board runs with the 32.768KHz clock input. I didn't know
there are boards that use this as the reference clock. It seems this
is not handled in the current clk code. Could you test the patch I just
sent to the mailing list (Cced you) and provide a Tested-by tag if it
works? The clock frequency provided in the device tree shouldn't make
a difference then anymore. You should specify it to 0 if you have
nothing connected there.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
