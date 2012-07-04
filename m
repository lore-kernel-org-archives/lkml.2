Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2GDOSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:18:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40303 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2GDOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:18:05 -0400
Date: Wed, 4 Jul 2012 16:17:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: ethernet-related thermal emergency on Thinkpad x60
Message-ID: <20120704141756.GA2089@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

When using nework interface (eth0), machine starts to behave
weird. Like... complete freeze, then poweroff, then it hangs on boot
(initializing ACPI) until I let it to cool down... and I'm not even
using gigabit speed.

Did anyone see it? Any ideas? Should I attempt to open it and clean
the dust?

									Pavel

e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
e1000e 0000:02:00.0: eth0: 10/100 speed: disabling TSO
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051c00.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is extremely hot!
thinkpad_acpi: temperatures (Celsius): 88 49 N/A 82 40 N/A 40 N/A 52 61 N/A N/A N/A N/A N/A N/A


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
