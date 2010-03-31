Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab0CaIPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:15:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54977 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab0CaIPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:15:06 -0400
Date: Wed, 31 Mar 2010 10:15:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Bryan Wu <bryan.wu@canonical.com>, gerg@uclinux.org,
       amit.kucheria@canonical.com, kernel-team@lists.ubuntu.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
	detection
Message-ID: <20100331081502.GQ2241@pengutronix.de>
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com> <20100331075746.GO2241@pengutronix.de> <20100331081004.GB23391@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331081004.GB23391@pengutronix.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:12:56 up 10 days, 21:02, 33 users,  load average: 0.54, 0.23,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:10:04AM +0200, Wolfram Sang wrote:
> > With rounding this would be:
> > 
> > (clk_get_rate() + 4999999) / 5000000
> 
> Better use DIV_ROUND_UP(clk_get_rate(), 5000000)?

Yes.
Sometimes I wish the useful assorted kernel helper of the day in my
fortune :)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
