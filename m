Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2BBCy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:54:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52516 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2BBCy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:54:27 -0500
Message-ID: <1328151229.2342.110.camel@work-vm>
Subject: [GIT PULL] Clocksource changes for 3.4
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Wed, 01 Feb 2012 18:53:49 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020202-1780-0000-0000-000002CE7797
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110152; UDB=6.00027396; UTC=2012-02-02
 02:54:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Just wanted to send you my current 3.4 queue for clocksource changes.
Since tip/timers/core hasn't been updated since 3.3 was out, these are
against Linus' head (actually, from a week or so ago). Let me know if
you'd like me to base them off of something else.

thanks
-john


The patches are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/clocksource

Arjan van de Ven (1):
      clocksource: Load the ACPI PM clocksource asynchronously

Jim Cromie (1):
      clocksource: scx200_hrt:  use pr_<level> instead of printk

John Stultz (1):
      clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz

Julia Lawall (1):
      clocksource: cyclone: Add missing iounmap

Yong Zhang (2):
      clocksource: dbx500: convert to clocksource_register_hz()
      clocksource: Get rid of clocksource_calc_mult_shift()

 drivers/clocksource/acpi_pm.c             |   24 ++++++++++++++++--------
 drivers/clocksource/clksrc-dbx500-prcmu.c |    5 +----
 drivers/clocksource/cyclone.c             |    2 +-
 drivers/clocksource/scx200_hrt.c          |   22 ++++++++--------------
 include/linux/clocksource.h               |    7 -------
 5 files changed, 26 insertions(+), 34 deletions(-)

