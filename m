Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2JUKip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:38:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37644 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JUKio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:38:44 -0400
Date: Sun, 21 Oct 2012 12:38:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] Staging: winbond: phy_calibration: Fixed coding
 style issue
Message-ID: <20121021103838.GC14031@elf.ucw.cz>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
 <1350059835-5408-3-git-send-email-mujeeb.adil@gmail.com>
 <1350060799.2243.31.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350060799.2243.31.camel@joe-AO722>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2012-10-12 09:53:19, Joe Perches wrote:
> On Fri, 2012-10-12 at 22:07 +0530, Adil Mujeeb wrote:
> > Removed checkpatch.pl script reported ERRORs
> []
> > diff --git a/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c b/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c
> []
> > -#define AG_CONST        0.6072529350
> > +#define AG_CONST        (0.6072529350)
> 
> That one is unnecessary.
> checkpatch is defective here.

Agreed.

> I wonder why there is any floating point
> in the code at all though.

Some kind of signal strength computations. I'm not an wifi expert... :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
