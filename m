Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2IRH55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:57:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46872 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2IRH54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:57:56 -0400
Date: Tue, 18 Sep 2012 09:57:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 5/7] pwm: i.MX: add devicetree support
Message-ID: <20120918075748.GQ6180@pengutronix.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
 <1347267577-3296-6-git-send-email-s.hauer@pengutronix.de>
 <20120911144043.GA3824@avionic-0098.mockup.avionic-design.de>
 <20120912090458.GN6180@pengutronix.de>
 <20120918061154.GB1459@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918061154.GB1459@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:56:49 up 86 days, 23:08, 34 users,  load average: 0.09, 0.26,
 0.85
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:11:55AM +0200, Thierry Reding wrote:
> On Wed, Sep 12, 2012 at 11:04:58AM +0200, Sascha Hauer wrote:
> > 
> > 
> > The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:
> > 
> >   Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.pengutronix.de/git/imx/linux-2.6.git tags/imx-pwm-oftree
> > 
> > for you to fetch changes up to a1d38ca9e249e670aa9f608e1cc7491fb4ca45af:
> > 
> >   pwm: i.MX: fix clock lookup (2012-09-12 11:00:55 +0200)
> > 
> > ----------------------------------------------------------------
> > Cleanup i.MX PWM driver and add devicetree support
> > 
> > ----------------------------------------------------------------
> > Philipp Zabel (2):
> >       pwm: i.MX: add devicetree support
> >       pwm: i.MX: fix clock lookup
> > 
> > Sascha Hauer (5):
> >       pwm: i.MX: factor out SoC specific functions
> >       pwm: i.MX: remove unnecessary if in pwm_[en|dis]able
> >       pwm: i.MX: add functions to enable/disable pwm.
> >       pwm: i.MX: Use module_platform_driver
> >       pwm: i.MX: use per clock unconditionally
> > 
> >  Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++
> >  drivers/pwm/pwm-imx.c                             |  278 ++++++++++++++-------
> >  2 files changed, 199 insertions(+), 96 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt
> 
> Applied, thanks. On a side note, I decided to pull the branch, extract
> the patches and apply them to my tree with git am, so this won't show up
> as a proper merge. This is all still pretty new to me and I'm still in
> the process of finding out what works best, so I hope you don't mind.

Thanks Thierry. I don't mind at all.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
