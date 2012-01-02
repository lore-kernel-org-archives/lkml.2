Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab2ABBGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 20:06:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30292 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2ABBGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 20:06:42 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-72-4f010320c30c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Grant Likely'" <grant@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <20111229140053.GA25479@sirena.org.uk>
In-reply-to: <20111229140053.GA25479@sirena.org.uk>
Subject: RE: [PATCH 0/4] Random GPIO updates
Date: Mon, 02 Jan 2012 10:06:38 +0900
Message-id: <037701ccc8ea$c7fc3980$57f4ac80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczGMkqmAOrRy9NYRIGnPkMq9ZbuTwAZLj7g
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
> On Thu, Dec 08, 2011 at 12:22:57AM +0800, Mark Brown wrote:
> 
> > This is a fairly random selection of updates I've been sitting on for
> > the gpios, partly built up over your sabbatical but a couple predating
> > that.  No real theme here except for time.
> 
> Adding Linus to the CCs for this since he became GPIO comaintainer
> (sorry, should've done this when reposting the patches).
> 
Hi Linus,

For Samsung stuff:
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> > The following changes since commit
> 5611cc4572e889b62a7b4c72a413536bf6a9c416:
> 
> >   Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)
> 
> > are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git
> gpio/misc
> 
> > Mark Brown (4):
> >       gpio: Explicitly index samsung_gpio_cfgs
> >       gpio: Fix typo in comment in Samsung driver
> >       gpio: Convert GPIO drivers to module_platform_driver
> >       gpio: Add decode of WM8994 GPIO configuration
> 
> >  drivers/gpio/gpio-adp5520.c    |   12 +------
> >  drivers/gpio/gpio-cs5535.c     |   13 +------
> >  drivers/gpio/gpio-da9052.c     |   12 +------
> >  drivers/gpio/gpio-generic.c    |   12 +------
> >  drivers/gpio/gpio-janz-ttl.c   |   13 +------
> >  drivers/gpio/gpio-rdc321x.c    |   13 +------
> >  drivers/gpio/gpio-samsung.c    |   31 ++++++++++------
> >  drivers/gpio/gpio-sch.c        |   13 +------
> >  drivers/gpio/gpio-timberdale.c |   13 +------
> >  drivers/gpio/gpio-ucb1400.c    |   13 +------
> >  drivers/gpio/gpio-vr41xx.c     |   13 +------
> >  drivers/gpio/gpio-vx855.c      |   12 +------
> >  drivers/gpio/gpio-wm8994.c     |   79
> +++++++++++++++++++++++++++++++++++++++-
> >  13 files changed, 108 insertions(+), 141 deletions(-)

