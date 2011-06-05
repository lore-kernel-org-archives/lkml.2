Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1FEPJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:09:21 -0400
Received: from imr4.ericy.com ([198.24.6.8]:39620 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1FEPJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:09:20 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: =?UTF-8?q?=5BGIT=20PULL=5D=20hwmon=20fixes=20for=203=2E0?=
Date: Sun, 5 Jun 2011 08:06:58 -0700
Message-ID: <1307286418-26876-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.0 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (2):
      hwmon: (coretemp) Fix TjMax detection for older CPUs
      hwmon: (coretemp) Further relax temperature range checks

Jean Delvare (1):
      hwmon: (coretemp) Relax target temperature range check

Per Dalen (1):
      hwmon: (max6642) Rename temp_fault sysfs attribute to temp2_fault

Per Dalén (1):
      hwmon: (max6642): Better chip detection schema

 drivers/hwmon/coretemp.c |   23 ++++-------------------
 drivers/hwmon/max6642.c  |   22 ++++++++++++++++++----
 2 files changed, 22 insertions(+), 23 deletions(-)
