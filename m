Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2AXAGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:06:17 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51666 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab2AXAGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:06:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jim Cromie <jim.cromie@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: [RFC][PATCH 0/3] Last of the clocksource_register_hz cleanups
Date: Mon, 23 Jan 2012 16:05:47 -0800
Message-Id: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012400-7282-0000-0000-000005DDD2DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm hoping to finally kill off clocksource_register(), so I wanted
to get the last of the hardware specific clocksources changes that I
cannot test to be reviewed by maintainers.

In some cases the patches are not clearly correct, or the existing
code is broken and I don't know how to fix it. So feedback here
would be greatly appreciated!

thanks
-john

CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Jim Cromie <jim.cromie@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Yong Zhang <yong.zhang0@gmail.com>

John Stultz (3):
  clocksource: s390: Convert s390 to use clocksource_register_khz
  clocksource: scx200_hrt: Convert scx200 to use
    clocksource_register_hz
  clocksource: Convert mips pnx8550 to use clocksource_register_hz

 arch/mips/pnx8550/common/time.c  |    7 ++++++-
 arch/s390/kernel/time.c          |   13 ++++++++++---
 drivers/clocksource/scx200_hrt.c |   19 ++++++-------------
 3 files changed, 22 insertions(+), 17 deletions(-)

-- 
1.7.3.2.146.gca209

