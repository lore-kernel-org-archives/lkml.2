Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1JXPQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:16:52 -0400
Received: from [213.95.27.120] ([213.95.27.120]:39609 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab1JXPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:16:51 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/3] mfd: S5M series initial release
Date: Sun, 23 Oct 2011 16:29:59 +0900
Message-Id: <1319355002-12674-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung is developing various multi function devices.
Currently, 3 devices are announced by samsung.
S5M8767 has pmic and rtc and battery charger.
S5M8763 has pmic, rtc, Li-ion battery charger
S5M8751 has pmic, codec, battery charger, backlight controller.
All devices are designed for mobile applications.
Sequencially, All driver will be posted.
This is initial version for MFD of S5M series.
The other driver will be submitted  separately.

[PATCH 1/3] mfd: Add S5M core driver
[PATCH 2/3] mfd: Add s5m series irq support
[PATCH 3/3] mfd: Add S5M series configuration
