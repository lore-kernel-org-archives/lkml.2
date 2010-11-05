Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0KERQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:16:16 -0400
Received: from imr3.ericy.com ([198.24.6.13]:34410 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0KERQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:16:14 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.37
Date: Fri, 5 Nov 2010 10:33:19 -0700
Message-ID: <1288978399-16583-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.37 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit ff8b16d7e15a8ba2a6086645614a483e048e3fbf:

  vmstat: fix offset calculation on void* (2010-11-03 14:39:58 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (1):
      hwmon: (ltc4261) Add missing newline in debug message

Jean Delvare (1):
      hwmon: (ltc4261) Fix error message format

 drivers/hwmon/ltc4261.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)
