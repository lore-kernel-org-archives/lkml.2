Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1KVT33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:29:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41060 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1KVT31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:29:27 -0500
Date: Tue, 22 Nov 2011 20:30:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 regression: floppy driver breaks boot
Message-ID: <20111122193030.GA2164@elf.ucw.cz>
References: <20111122111405.GA28215@elf.ucw.cz>
 <20111122142121.GB2013@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122142121.GB2013@gherkin.frus.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2011-11-22 08:21:21, Bob Tracy wrote:
> On Tue, Nov 22, 2011 at 12:14:06PM +0100, Pavel Machek wrote:
> > 3.2-rc1..rc2 fail to boot, due to some warn-on in block layer. It
> > seems that floppy driver is responsible.
> > 
> > I'll try to turn the floppy driver off and see what happens.

Without floppy support my x60 boot. iwlwifi driver
(CONFIG_IWLWIFI_LEGACY=y) went crazy after hibernation, but thats
separate issue.

> > Seems like floppy driver has no maintianer :-(.
> 
> Might be my issue as well.  I've got an old AMD K6-III/450 system with
> two floppy drives.  When booting 3.2-rc2 (didn't try "-rc1"), the system
> switches video modes (VESA FB console), and then hangs/panics.  No
> further info available because the panic happens too early for syslog to
> record it, and the console goes blank at the time of the mode switch:
> there's nothing on the screen I might transcribe manually.  3.1-final

Try turning off floppy support. That helped for me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
