Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0I1L1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:27:00 -0400
Received: from imr3.ericy.com ([198.24.6.13]:49761 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab0I1L06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:26:58 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] urgent hwmon fixes for 2.6.36
Date: Tue, 28 Sep 2010 04:34:43 -0700
Message-ID: <1285673683-28202-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.36 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

Guenter Roeck (1):
      hwmon (coretemp): Fix build breakage if SMP is undefined

 drivers/hwmon/coretemp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
