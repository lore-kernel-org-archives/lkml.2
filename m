Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1GBBQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:16:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59292 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab1GBBQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:16:41 -0400
Subject: [GIT PULL] Time changes for 3.1
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 18:16:36 -0700
Message-ID: <1309569396.2872.400.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

        I have a few time changes for 3.1 that are available in the git
repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.1/tip/timers/time

Would you please consider queuing these into -tip for 3.1?

thanks
-john


John Stultz (3):
      time: Catch invalid timespec sleep values in __timekeeping_inject_sleeptime
      time: Avoid accumulating time drift in suspend/resume
      rtc: Avoid accumulating time drift in suspend/resume

 drivers/rtc/class.c       |   65 +++++++++++++++++++++++++++++++++------------
 kernel/time/timekeeping.c |   28 +++++++++++++++++++
 2 files changed, 76 insertions(+), 17 deletions(-)


