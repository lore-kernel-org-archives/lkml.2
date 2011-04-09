Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1DIQiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 12:38:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39835 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754662Ab1DIQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 12:38:07 -0400
Date: Sat, 9 Apr 2011 18:37:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thilo-Alexander Ginkel <thilo@ginkel.com>, linux-kernel@vger.kernel.org
Subject: Re: Soft lockup during suspend since ~2.6.36
Message-ID: <20110409163736.GA1468@ucw.cz>
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
 <201104041640.15578.arnd@arndb.de>
 <BANLkTim4Ro+u-9jfLPV1-+tM88xtvN-VTg@mail.gmail.com>
 <201104041732.42489.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104041732.42489.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ACK. I see two possibilities:
> > a) The bug was introduced after the bisected bug was fixed
> > b) The bug was already present earlier, but was masked by the bug from
> > the bisected change
> > 
> > I hope for a) as that would open the possibility to bisect this new bug.
> 
> In case of b), you can still bisect it when you either apply the later fix
> or revert the original patch whenever you build a kernel. Or you can try
> to avoid using the usb-hid driver during bisect.

As this is both suspend problem and regression... you may want to cc: rjw.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
