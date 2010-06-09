Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0FIID2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:03:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34119 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab0FIIDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:03:22 -0400
Date: Wed, 9 Jun 2010 09:35:25 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: unable to fetch i.MX tree
Message-ID: <20100609073525.GE20799@pengutronix.de>
References: <20100609100526.913a49bb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609100526.913a49bb.sfr@canb.auug.org.au>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:33:17 up 2 days, 1 min, 33 users,  load average: 0.35, 0.33,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jun 09, 2010 at 10:05:26AM +1000, Stephen Rothwell wrote:
> Hi Sascha,
> 
> When I try to fetch the i.MX tree, I get these errors:
> 
> git.pengutronix.de[0: 92.198.50.42]: errno=Connection timed out
> git.pengutronix.de[0: 2001:6f8:1178:4:230:48ff:fe91:5e78]: errno=Network is unreachable
> fatal: unable to connect a socket (Network is unreachable)
> 
> I will use the i.MX tree from next-20100608 for today.

No problem, we were offline for a day. Should now work again.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
