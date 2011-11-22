Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab1KVLOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:14:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1KVLOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:14:08 -0500
Date: Tue, 22 Nov 2011 12:14:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: 3.2-rc2 regression: floppy driver breaks boot
Message-ID: <20111122111405.GA28215@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

3.2-rc1..rc2 fail to boot, due to some warn-on in block layer. It
seems that floppy driver is responsible.

I'll try to turn the floppy driver off and see what happens.

Seems like floppy driver has no maintianer :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
