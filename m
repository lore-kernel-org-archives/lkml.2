Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab1EaUb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:31:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60003 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758399Ab1EaUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:31:27 -0400
Date: Tue, 31 May 2011 22:31:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
Message-ID: <20110531203106.GB4424@elf.ucw.cz>
References: <4DE3E9E7.8020008@zytor.com>
 <20110531194358.GA4424@elf.ucw.cz>
 <201105312204.02722.arnd@arndb.de>
 <4DE54BFF.5090508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE54BFF.5090508@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2011-05-31 13:13:51, H. Peter Anvin wrote:
> On 05/31/2011 01:04 PM, Arnd Bergmann wrote:
> > 
> > Are you talking about just ftp://ftp.kernel.org/pub/linux/kernel/*/incr/
> > or also about ftp://ftp.kernel.org/pub/linux/kernel/v2.6/patch-* and
> > Changelog-*?
> > 
> > I can see reasons to keep the latter, but not necessarily the former.
> 
> The former only.

Aha, I guess I have to agree... /incr/ is not terribly
important. Anyone doing _that_ kind of development probably has git.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
