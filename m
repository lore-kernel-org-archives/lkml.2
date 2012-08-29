Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2H2HlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 03:41:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43737 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2H2HlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 03:41:23 -0400
Date: Wed, 29 Aug 2012 09:41:22 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: mxc_nand.c on mach-imx/imx53
Message-ID: <20120829074122.GV26594@pengutronix.de>
References: <5035F84E.3000901@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5035F84E.3000901@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:40:28 up 66 days, 22:52, 45 users,  load average: 0.46, 0.67,
 0.74
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Thu, Aug 23, 2012 at 11:30:54AM +0200, Roland Stigge wrote:
> Hi,
> 
> I'd like to know about the current state of mxc_nand.c on imx53, because
> I got an error on probe() because the clock that mxc_nand is requesting
> is "nfc" but imx53 only defines the clock "mxc_nand".

The driver generally works on i.MX53, only some pieces are missing. I
just resent the corresponding series and put you on Cc.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
