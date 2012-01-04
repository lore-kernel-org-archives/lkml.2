Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2ADDgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 22:36:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50162 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2ADDgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 22:36:17 -0500
Message-ID: <1325648169.3037.84.camel@work-vm>
Subject: RTC revert request
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, NeilBrown <neilb@suse.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        lkml <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Date: Tue, 03 Jan 2012 19:36:09 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010403-2398-0000-0000-00000326B1BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,
	Over the holiday break, its been found that a couple of the RTC fixes I
pushed out have been causing worse problems on some hardware then they
fix.

Thus, would you please revert:

93b2ec0128c431148b216b8f7337c1a52131ef03
rtc: Expire alarms after the time is set.

and 

c0afabd3d553c521e003779c127143ffde55a16f
rtc: Disable the alarm in the hardware


I'll work with the Neil and Rabin to make sure the issues these patches
try to address get properly fixed for 3.3.

Sorry again for these late regressions.


Greg: I think you've already picked up "rtc: Disable the alarm in the
hardware" and will need to revert that too.  Again, my apologies.

thanks
-john


