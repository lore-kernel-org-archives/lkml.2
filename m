Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2EUXkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:40:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53617 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2EUXka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:40:30 -0400
Message-ID: <4FBAD268.4090308@us.ibm.com>
Date: Mon, 21 May 2012 16:40:24 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [GIT PULL] Time/NTP cleanups for 3.5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052123-7182-0000-0000-00000190FE14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Just wanted to send a few time/ntp cleanups and one fix from 
Richard.  These are top of tip/timers/core.

The following changes since commit bdebaf80a02b854381fe212e0dac13c8c8edac57:

   x86: Use generic time config (2012-05-21 11:01:44 +0200)

are available in the git repository at:
   git://git.linaro.org/people/jstultz/linux.git fortglx/3.5/time

Richard Cochran (4):
       ntp: Correct TAI offset during leap second
       ntp: Fix a stale comment and a few stray newlines.
       time: remove obsolete declaration
       timekeeping: Fix a few minor newline issues.

  include/linux/time.h      |    1 -
  kernel/time/ntp.c         |    8 +++-----
  kernel/time/timekeeping.c |    4 +---
  3 files changed, 4 insertions(+), 9 deletions(-)

