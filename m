Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab2EPSEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:04:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2EPSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:04:36 -0400
Date: Wed, 16 May 2012 20:04:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: Tree for May 16 (mfd/mc13xxx)
Message-ID: <20120516180427.GM22395@pengutronix.de>
References: <20120516201426.3a162ecd6adeb7132413f1b9@canb.auug.org.au>
 <4FB3CF4E.8000106@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB3CF4E.8000106@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:01:18AM -0700, Randy Dunlap wrote:
> On 05/16/2012 03:14 AM, Stephen Rothwell wrote:
> 
> > 
> > The mfd tree lost its build failure but gained another so I used the
> > version from next-20120511.
> 
> 
> drivers/mfd/mc13xxx-core.c:726:2: error: implicit declaration of function 'regmap_exit'
I think the patch by Mark Brown[1] addresses that problem?

Best regards
Uwe

[1] http://mid.gmane.org/1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
