Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab2AKIek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:34:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52332 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2AKIej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:34:39 -0500
Date: Wed, 11 Jan 2012 09:34:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: please update the i.MX tree
Message-ID: <20120111083429.GU5446@pengutronix.de>
References: <20120110115218.e00ab8c01abd5b9ae9a3b166@canb.auug.org.au>
 <20120110083020.GR5446@pengutronix.de>
 <20120111093457.af3caeabe2dbf50b70942334@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111093457.af3caeabe2dbf50b70942334@canb.auug.org.au>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:32:27 up 59 days, 16:19, 21 users,  load average: 0.21, 0.07,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 09:34:57AM +1100, Stephen Rothwell wrote:
> Hi Sascha,
> 
> On Tue, 10 Jan 2012 09:30:20 +0100 Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >
> > On Tue, Jan 10, 2012 at 11:52:18AM +1100, Stephen Rothwell wrote:
> > > 
> > > It looks like most (if not all) of the i.MX tree has been merged into the
> > > arm-soc (and Linus') tree, so could you please update the i.MX tree to
> > > eliminate the conflicts I am getting.
> > 
> > Did this. Sorry, I was not aware that there is something in this branch.
> 
> Did you push it out? I just checked and it hasn't changed. Just to be
> clear, I am fetching git://git.pengutronix.de/git/imx/linux-2.6.git
> branch for-next and it hasn't changed since last September.

I failed to wait until my push returned. It failed due to
non-fast-forward pushing. Really fixed this now.

> 
> Should I, instead, just remove that tree from linux-next and let you send
> stuff just via the arm-soc (or arm)tree?

Yes, that's probably best. That's what I do anyway.

Sascha



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
