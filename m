Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0CVUoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:44:15 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:5676 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0CVUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:44:13 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 16:44:13 EDT
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMpxp0utJV2c/2dsb2JhbACbJ3OkH4sUCY0wgmqCEwQ
X-IronPort-AV: E=Sophos;i="4.51,289,1267401600"; 
   d="scan'208";a="94985665"
Subject: 2.6.31 Momentary Hang
From: Danny Cox <danncox@cisco.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Organization: Cisco
Date: Mon, 22 Mar 2010 16:34:36 -0400
Message-ID: <1269290076.16688.1814.camel@atllxdanncox.cisco.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2010 20:34:36.0692 (UTC) FILETIME=[16A02D40:01CAC9FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Gurus,

	A colleague of mine is experiencing severe Denial Of Service multiple
times a day.  When a disk intensive process is started, in our case, a
Subversion check out, we observe the load average spike from 6 to 10,
all CPUs are at idle, but the IO wait time is in the thousands of
milliseconds (1500 - 3000).  If we wait long enough, the load average
begins to drop, but will hover around 5 for a couple of minutes.
Afterward, it will quickly drop toward 0.

	The machine is fairly new, having been purchased in the December
timeframe.  It uses an ASUS P7P55D-LE with an Intel Core I7 860 with 8
GB of ram.  It is running Ubuntu 9.10 with all patches applied.  The
kernel is 2.6.31-20.  It uses two WD 500 GB Caviar green drives, with
software RAID1 on 3 of the partitions: /, /boot, and /home.

	During the hang time, almost nothing can be started.  We've been using
top, atop, vmstat, and the Gnome system monitor to see what's occurring.
Our only hints are the high load average, and the I/O wait times.

	At this point, Google has been unable to provide answers, and my
colleague is ready to perform physical violence on the system.  I don't
even know what I can or should measure next.  Hints are welcome.  A
solution would be even better, if any of the above strikes a chord.

	One other data point: we have 5+ other identical systems, none of which
have this issue.  My colleague notes that his system was fine for a
couple of weeks.  It is possible that he installed some package that
causes this behavior.  That's merely speculation, of course.

	Please include me in the CC: header, as I'm not subscribed to
linux-kernel.  I'd like to be, but the volume is too much.

	Thanks for your time!

P.S.  Things we've tried:

* move the drives to another (identical) machine.  The issue persists.

* disable one of the drives in the RAID.  The issue persists.


-- 
Danny Cox
770-236-6148
Cisco
Service Provider Video Technology Group

