Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1LMJiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:38:23 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:41109 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751052Ab1LMJiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:38:20 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Subject: [PATCH V2 0/2] pinctrl: support PXA series
Date: Tue, 13 Dec 2011 17:40:51 +0800
Message-Id: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 13 Dec 2011 09:38:09.0089 (UTC) FILETIME=[EC712B10:01CCB97A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v1->v2:
1. Split pxa3xx pinmux driver to more pieces.
2. Add PXA168/PXA910/PXA930/MMP2 silicon support.
3. Now only enable it in arch-mmp.
4. Now all predefined pins are enabled by default. Although some devices
are not used, they would be declared in arch-pxa. It would result define
unnecessary pins in platform.
5. Remove gpio support since it's depend on some gpio-pxa patches in
arm-soc trees.

