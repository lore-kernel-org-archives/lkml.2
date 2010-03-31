Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0CaIMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:12:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab0CaIMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:12:12 -0400
Date: Wed, 31 Mar 2010 10:12:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Bryan Wu <bryan.wu@canonical.com>, gerg@uclinux.org,
       netdev@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       w.sang@pengutronix.de
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
	detection
Message-ID: <20100331081208.GP2241@pengutronix.de>
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com> <20100326102957.GG5539@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326102957.GG5539@matterhorn.verdurent.com>
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
X-Uptime: 09:58:08 up 10 days, 20:47, 21 users,  load average: 0.58, 0.52,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:29:57PM +0200, Amit Kucheria wrote:
> On 10 Mar 26, Bryan Wu wrote:
> > BugLink: http://bugs.launchpad.net/bugs/457878
> > 
> >  - removed old MII phy control code
> >  - add phylib supporting
> >  - add ethtool interface to make user space NetworkManager works
> > 
> > Tested on Freescale i.MX51 Babbage board.
> > 
> > This patch is based on a patch from Frederic Rodo <fred.rodo@gmail.com>
> > 
> > Cc: Frederic Rodo <fred.rodo@gmail.com>
> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 
> While I ack this patch, I wonder if we should add to the various board
> Kconfig options, a dependency select'ing the right phylib for that board.
> 
> This would prevent breakage of ethernet on those boards because they forgot
> to select the right phylib after this change.

I wouldn't go that far. I never saw a board which doesn't work with the
generic phy implementation, so I would only select the specific phy if
I knew that the generic phy does not work.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
