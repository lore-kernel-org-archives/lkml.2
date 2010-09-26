Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab0I0UXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:23:51 -0400
Received: from imr3.ericy.com ([198.24.6.13]:46251 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab0I0UXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:23:50 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.36 - take two
Date: Sun, 26 Sep 2010 12:58:59 -0700
Message-ID: <1285531139-16646-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.36 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

This is a single commit which fixes the built breakage introduced with the
series I sent out yesterday. For your convenience, I also copied you on the 
patch itself.

Thanks,
Guenter Roeck

------

Guenter Roeck (1):
      hwmon (coretemp): Fix build breakage if SMP is undefined

 drivers/hwmon/coretemp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
