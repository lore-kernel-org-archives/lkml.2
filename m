Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab1JXPQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:16:55 -0400
Received: from [213.95.27.120] ([213.95.27.120]:39621 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab1JXPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:16:53 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/3] mfd: S5M core driver initial release
Date: Fri, 21 Oct 2011 19:28:11 +0900
Message-Id: <1319192894-19292-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung has released various MFD series.
S5M8767 has pmic and rtc and battery charger.
S5M8763 has pmic, rtc, battery charger.
S5M8751 has pmic, codec, battery charger, backlight controller.
All devices are designed for mobile applications.
Sequencially, All driver will be posted.
This is initial version for MFD of S5M series.
The other driver will be submitted  separately.

Thanks,
Sangbeom.
