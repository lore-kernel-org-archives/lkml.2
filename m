Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2L3TkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 14:40:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60828 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab2L3TkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 14:40:00 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] [regmap] Add "no-bus" configuration for regmap API
Date: Sun, 30 Dec 2012 11:39:46 -0800
Message-Id: <1356896389-4098-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version of the initial patchset(can be found here:
https://lkml.org/lkml/2012/12/21/98)

This version contains following improvements:
 - Provisions to switch between mutexes and spinlocks for locking in
   "no-bus" configuration
 - "reg_read" and "reg_write" have "void *context" as a first argument
   in all the patches
 - Minor improvements in documentation

Andrey Smirnov (3):
  Add provisions to have user-defined read operation
  Add provisions to have user-defined write operation
  Add "no-bus" option for regmap API

 drivers/base/regmap/internal.h |    5 ++
 drivers/base/regmap/regmap.c   |  156 +++++++++++++++++++++++++++++-----------
 include/linux/regmap.h         |   18 ++++-
 3 files changed, 135 insertions(+), 44 deletions(-)

-- 
1.7.9.5

