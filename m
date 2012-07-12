Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2GLKMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:12:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37286 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759108Ab2GLKMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:12:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 0/7] PM / I2C: Convert platform I2C drivers to PM handling based on struct dev_pm_ops
Date: Thu, 12 Jul 2012 12:17:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Vitaly Wool <vitalywool@gmail.com>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <201207112121.11046.rjw@sisk.pl> <20120712100901.GE27520@pengutronix.de>
In-Reply-To: <20120712100901.GE27520@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207121217.44910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 12, 2012, Wolfram Sang wrote:
> On Wed, Jul 11, 2012 at 09:21:10PM +0200, Rafael J. Wysocki wrote:
> > Hi all,
> > 
> > As per
> > 
> > http://marc.info/?l=linux-kernel&m=133996733422413&w=4
> > 
> > the following patches convert some platform I2C controller drivers to the PM
> > handling based on struct dev_pm_ops:
> > 
> > [1/7] i2c-at91: Use struct dev_pm_ops for power management
> > [2/7] i2c-bfin-twi: Use struct dev_pm_ops for power management
> > [3/7] i2c-ocores: Use struct dev_pm_ops for power management
> > [4/7] i2c-pnx: Use struct dev_pm_ops for power management
> > [5/7] i2c-puv3: Use struct dev_pm_ops for power management
> > [6/7] i2c-stu300: Use struct dev_pm_ops for power management
> > [7/7] i2c-tegra: Use struct dev_pm_ops for power management
> > 
> > I'd like to include them into my PM pull request for 3.6 if there are no
> > objections.
> 
> The changes are fine by me. I'd like to pull them in via I2C, though,
> since they are changing mostly drivers for which I have other patches in
> the pile and I'd like to see the conflicts myself. Is that okay? They'd
> be in linux-next tomorrow.

Cool, thanks for handling them! :-)

> Or is there a dependency I missed?

No, there shouldn't be any.

Thanks,
Rafael
