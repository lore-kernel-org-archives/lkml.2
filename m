Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2EOSKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:10:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53622 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab2EOSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:10:16 -0400
Date: Tue, 15 May 2012 20:10:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: thinkpad x60: critical thermal shutdown does not work (and ethernet
 overheats)
Message-ID: <20120515181004.GA2499@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have rather old thinkpad x60 here. Long time ago, I noticed that on
high continuous ethernet load, it shuts itself down in regular
way. I traced it down to overheat, followed by ACPI signaling system
to go down.

This no longer works in recent kernels. (3.4-rc7 tested, but probably
it does not work correctly in 3.2 either). Now machine just hangs when
it should start /sbin/poweroff. If I then turn it on, it hangs during
ACPI init. I have to let it cool down, then it can boot.

Now:

a) Any ideas how to solve the overheating problem? Is it hw or sw? Are
there workarounds... like should I go to 10mbit? (It overheats even
under 2MB/sec continuous load...). Is it common thinkpad fault?

b) Why did it stop shutting down correctly? Can you reproduce it by
overheating machine artifically?

Ideas?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
