Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303Ab0J0N4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:56:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49029 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761261Ab0J0N4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:56:47 -0400
Date: Wed, 27 Oct 2010 15:56:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
Message-ID: <20101027135642.GM6017@pengutronix.de>
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com> <20101027082958.GA6797@angua.secretlab.ca> <20101027090921.GB8554@pengutronix.de> <20101027102253.GA7822@angua.secretlab.ca> <20101027132213.GJ6017@pengutronix.de> <4CC82A13.8000909@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CC82A13.8000909@eukrea.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:55:38 up 116 days,  5:06, 49 users,  load average: 0.22, 0.20,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:33:07PM +0200, Eric Bénard wrote:
> Hi,
>
> Le 27/10/2010 15:22, Sascha Hauer a écrit :
> > That's a way we can go but only if the common name is not MX5 or MX5x.
> > We've done it with the mx21/27 and it failed when the mx25 came out
> > which was completely incompatible. Since then everybody looking at
> > the code must know that mx2x is mx21/27 but not mx25. I suggest
> > something like MX513 instead.
> >
> MX513 is the partnumber of a member of the i.MX51 family so that's maybe 
> not the best choice.

Yes, I know. Is MX5_1_3 better? Any other suggestions?

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
