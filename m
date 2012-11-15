Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767857Ab2KOOCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:02:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43488 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767757Ab2KOOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:02:44 -0500
Date: Thu, 15 Nov 2012 15:02:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, jikos@suse.cz
Subject: Re: 3.7-rc3: mouses stopped working
Message-ID: <20121115140259.GA2224@elf.ucw.cz>
References: <20121115132849.GA4062@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115132849.GA4062@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm using thinkpad x60 with external USB mouse. On first boot, both
> mice stopped working after minute-or-so in X. Lets see if it breaks on
> the next boot, too..

Aha, happens on next boot, and mice are broken from the start.
Hmm. And even on console, gpm is not there, and if I try to start it
manually, it finds that /dev/input/mice: "no such device or
address". Manual "cat" gives same result.

/dev/input/mice is c 13, 63 device.

Looks like real regression here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
