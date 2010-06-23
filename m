Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0FWGrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:47:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0FWGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:47:15 -0400
Date: Wed, 23 Jun 2010 08:47:07 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mtd: mxc_nand fixups
Message-ID: <20100623064707.GN12115@pengutronix.de>
References: <80ljacb7l8.fsf@merkur.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80ljacb7l8.fsf@merkur.tec.linutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:45:58 up 15 days, 23:13, 45 users,  load average: 2.70, 2.72,
	1.60
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 06:58:59PM +0200, John Ogness wrote:
> Hi,
> 
> The following 5 patches fix several issues with the MXC NFC
> driver. These changes were tested using an i.MX35 with a 16-bit flash
> chip (2K pages, 64 pages per eraseblock).

All Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
