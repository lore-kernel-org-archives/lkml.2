Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1KJTel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:34:41 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41422 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab1KJTek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:34:40 -0500
Message-ID: <1320953625.10668.86.camel@work-vm>
Subject: [GIT PULL] clocksource:  Avoid possible mult overflows
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Chen Jie <chenj@lemote.com>,
        zhangfx <zhangfx@lemote.com>
Date: Thu, 10 Nov 2011 11:33:45 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111019-9360-0000-0000-000000803F7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo,
	Here's the revised fix to the mult overflow issue against
tip/timers/core. Let me know if you hit any other issues.

thanks
-john


  git://git.linaro.org/people/jstultz/linux.git formingo/3.2/tip/timers/core

John Stultz (1):
      clocksource: Avoid selecting mult values that might overflow when adjusted

 include/linux/clocksource.h |    3 +-
 kernel/time/clocksource.c   |   58 +++++++++++++++++++++++++++++++++++-------
 kernel/time/timekeeping.c   |    7 +++++
 3 files changed, 57 insertions(+), 11 deletions(-)


