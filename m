Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1DYUVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:21:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49849 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1DYUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:21:20 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Akihiro MAEDA <sola.1980.a@gmail.com>,
        Masashi YOKOTA <yokota@pylone.jp>
Subject: [PATCH 0/3][RFC] Virtual Battery Driver
Date: Mon, 25 Apr 2011 13:20:26 -0700
Message-Id: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For awhile now, there has been an out of tree virtual
battery driver that was created by Masashi YOKOTA
<yokota@pylone.jp> that folks have been using to test
battery UI functionality on boards that don't actually
have battery hardware.

More recently the power supply test driver (test_power.c)
has been merged.

Both drivers provide somwhat similar functionality,
although the virtual battery driver allows settings
such as health and charge state to be manipulated at
runtime via module params.

So while I'm not proposing to merge this patch set as 
is, I wanted to send it out for comment to see if there
would be some interest or objections for merging some of
the functionality from the virtual battery driver into
the test_power driver?

Thoughts?

thanks
-john


CC: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Akihiro MAEDA <sola.1980.a@gmail.com>
CC: Masashi YOKOTA <yokota@pylone.jp>

Akihiro MAEDA (1):
  power: virtual battery driver tweaks

John Stultz (1):
  power: Fixup stack usage in vritual battery driver

Masashi YOKOTA (1):
  power: Add virtual battery driver

 drivers/power/Kconfig           |    5 +
 drivers/power/Makefile          |    1 +
 drivers/power/virtual_battery.c |  400 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 406 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/virtual_battery.c

-- 
1.7.3.2.146.gca209

