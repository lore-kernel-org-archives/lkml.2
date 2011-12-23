Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1LXPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 10:09:58 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:34948 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1LXPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 10:09:25 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Samsung S5M series initial release
Date: Fri, 23 Dec 2011 17:28:07 +0900
Message-Id: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since v1:
- Modified regmap related functions.
- Add reg_enable_suspend function

Samsung is developing various multi function devices.
Currently, 3 devices are announced by samsung.
S5M8767 has pmic and rtc and battery charger.
S5M8763 has pmic, rtc, Li-ion battery charger
S5M8751 has pmic, codec, battery charger, backlight controller.
All devices are designed for mobile applications.
Sequentially, All driver will be posted.
This is initial version for MFD of S5M series.
The other driver will be submitted  separately.

Sangbeom

