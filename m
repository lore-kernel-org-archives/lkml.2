Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1LCPXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 10:23:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36255 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1LCPXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 10:23:22 -0500
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Subject: [PATCH] thermal: anatop thermal driver for imx6 platform
Date: Sat,  3 Dec 2011 23:22:58 +0800
Message-Id: <1322925779-15556-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

Dear all,

Please help me to review this thermal driver.
It uses Intel's thermal (drivers/thermal/thermal_sys.c) interface.
But looking into drivers/thermal I didn't find other drivers there.
I'm also thinking to put this driver into drivers/hwmon.
However, this driver doesn't create files in /sys/class/hwmon.

There are some discussions in
http://lists.linaro.org/pipermail/linaro-dev/2010-November/001626.html

There's currently no maintainers for drivers/thermal in MAINTAINERS in kernel
tree. So I send this mail to public mailing lists. Please give me some
comments.

Yours Sincerely,
Paul

Ying-Chun Liu (PaulLiu) (1):
  thermal: Add anatop thermal driver

 drivers/thermal/Kconfig          |   11 +
 drivers/thermal/Makefile         |    1 +
 drivers/thermal/anatop_driver.h  |  146 +++++++
 drivers/thermal/anatop_thermal.c |  825 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 983 insertions(+), 0 deletions(-)
 create mode 100644 drivers/thermal/anatop_driver.h
 create mode 100644 drivers/thermal/anatop_thermal.c

-- 
1.7.7.3

