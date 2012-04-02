Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2DBGkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:40:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57918 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2DBGka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:40:30 -0400
Date: Mon, 2 Apr 2012 08:40:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        oskar@scara.com, linux-kernel@vger.kernel.org, alexg@meprolight.com
Subject: Re: mc13xxx: add I2C support, V5
Message-ID: <20120402064012.GY15647@pengutronix.de>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
 <20120401092125.GX15647@pengutronix.de>
 <201204011939.49665.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201204011939.49665.marc@cpdesign.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marc,

On Sun, Apr 01, 2012 at 07:39:49PM +1000, Marc Reilly wrote:
> > On Sun, Apr 01, 2012 at 04:41:35PM +1000, Marc Reilly wrote:
> > > This series (against mfd-2.6/for-next) changes the mc13xxx driver to use
> > > regmap and adds I2C support.
> > > It has a compile dependency on regmap/for-next, as the spi driver uses
> > > the recently added pad_bits config field.
> > > 
> > > Patch 2/4 has:
> > > Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > Patch 4/4 has:
> > > Signed-off-by: Oskar Schirmer <oskar@scara.com>
> > 
> > You didn't add these tags to the respective patches. (And I think
> > Signed-off-by: Oskar is wrong. Maybe this should be an Ack?)
> 
> Whats the best/proper way to do this? Do I need to rebase the series and add 
> them with each relevant commit, or just add them manually to the patches? Or 
> option C...
Rebasing is ok, still more as you didn't publish your tree (at least I'm
not aware of it). The tags should definitly make it into the final
history. When you submit the patches via email it doesn't matter if you
add them to your git tree or only to the mail (as you tree doesn't
matter for the final result).

> For Oskar's tag, I just copied it from an email from the previous thread. 
Yeah, I saw it. That was already wrong. S-o-b is only for the author(s)
of a patch and the people forwarding it for inclusion (either via mail
or via a git tree). A S-o-b certifies that the patch's copyright is
suitable for the kernel. It doesn't say anything about its technical
impact.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
