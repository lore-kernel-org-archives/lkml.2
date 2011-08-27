Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1H0Akh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:40:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55076 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab1H0Akg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:40:36 -0400
Subject: [GIT PULL] Alarmtimer fixes for 3.1
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 17:40:31 -0700
Message-ID: <1314405631.2970.283.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo, Andrew,

	Again, these were sent out earlier but still haven't been pulled. I'm
leaving for vacation for the next two weeks (although I will
occasionally check email), so I wanted to resend this so it didn't get
missed.

In reviewing the alarmtimer code, I ran across a few bugs that should be
fixed for 3.1 and backported to 3.0-stable.

These are also available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/alarmtimers

The last of these is a pretty terrible hack, but I've got a more
invasive fix (along with other cleanups) queued on top of these for 3.2
that should resolve it. Feel free to take a peek at those changes here:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/alarmtimers

Let me know if you have any thoughts or feedback!

thanks
-john

John Stultz (3):
  alarmtimers: Avoid possible null pointer traversal
  alarmtimers: Memset itimerspec passed into alarm_timer_get
  alarmtimers: Avoid possible denial of service with high freq periodic
    timers

 kernel/time/alarmtimer.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)


