Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1DHFgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:36:53 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:59177
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418Ab1DHFgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:36:52 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Apr 2011 01:36:52 EDT
Date: Fri, 8 Apr 2011 07:29:21 +0200
From: Michael Guntsche <mike@it-loops.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [2.6.39-rc[12]] hangs during boot
Message-ID: <20110408052921.GA17375@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning list,

I just tried 2.7.39-rc2 and then rc1 on one of my systems.  2.6.38 runs
without an issue on this hardware but with 2.6.39-rc[12] the system
crawls to a halt during the boot process. I manages to reach the end of
runlevel S but then it grinds to a halt. Waiting long enough I get a
hung task warning sooner or later. If I then hit a SYSRQ combo for
blocked tasks (which is empty btw) it seems to continue a little bit but
awfully slow. 
The problem with debugging this right now is twofold.
First of all, for some odd reason I do not get output on the serial
console during boot (to capture the SYSRQ info), second this is running
on a software RAID-5 so every forced reboot out of this state results in
a complete resync of the whole array.

I know this could be everything, IRQ, block layer problem etc, so maybe
someone has an idea how I can figure out, what's going on exactly apart
from bisecting between 38 and 39-rc1

On a side note since I read similar reports already. This is a happening
with a CONFIG_NO_HZ/TICK_ONESHOT non-PREEMPT kernel.

Kind regards,
Michael Guntsche
