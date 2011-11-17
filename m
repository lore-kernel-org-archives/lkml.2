Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1KQXAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:00:38 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36320 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1KQXAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:00:37 -0500
Message-ID: <1321570771.25715.49.camel@work-vm>
Subject: [GIT PULL] ktime_get fix for arch_gettimeoffset users
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Hector Palacios <hector.palacios@digi.com>
Date: Thu, 17 Nov 2011 14:59:31 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111722-5518-0000-0000-00000078A786
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here's a fix from Hector Palacios for ktime_get/ktime_get_ts on systems
that utilize arch_gettimeoffset() that should probably go in for 3.2

thanks
-john

The fix against current tip/timers/core can be found here:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/core

Hector Palacios (1):
      timekeeping: add arch_offset hook to ktime_get functions

 kernel/time/timekeeping.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

