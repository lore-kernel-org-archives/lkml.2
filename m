Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1FYAxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 20:53:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57269 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1FYAxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 20:53:05 -0400
Subject: [Git PULL] RTC fix for 3.0
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Alexey Charkov <alchark@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 17:53:01 -0700
Message-ID: <1308963181.2872.148.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I've got an RTC build fix queued that should probably go in for 3.0. It
is available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.0/tip/timers/rtc

Alexey Charkov (1):
      rtc: vt8500: Fix build error & cleanup rtc_class_ops->update_irq_enable()

 drivers/rtc/rtc-vt8500.c |   45 +++------------------------------------------
 1 files changed, 3 insertions(+), 42 deletions(-)

thanks
-john


