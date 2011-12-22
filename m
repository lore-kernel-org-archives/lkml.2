Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1LVINY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:13:24 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:55240 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753518Ab1LVINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:13:23 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Subject: [PATCH v3 0/3] implement pinmux for arch-mmp
Date: Thu, 22 Dec 2011 16:17:32 +0800
Message-Id: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 22 Dec 2011 08:13:07.0079 (UTC) FILETIME=[891FF970:01CCC081]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#1 & #2 patch are based on pinctrl/for-next branch.
#3 patch is based on arm-soc/for-next branch since it replies the new pxa-gpio
driver.

Changelog v3->v2:
1. Avoid to use number in groups definition. Use macro instead.
2. Replace func array with mux array. There's a risk of align func array
and group array. Both pin and mux are defined in new mux array.
3. Support gpio again in gpio-pxa.
4. If multiple pins can be configured to same GPIO pin, define new specific
gpio group.

Changelog v1->v2:
1. Split pxa3xx pinmux driver to more pieces.
2. Add PXA168/PXA910/PXA930/MMP2 silicon support.
3. Now only enable it in arch-mmp.
4. Now all predefined pins are enabled by default. Although some devices
are not used, they would be declared in arch-pxa. It would result define
unnecessary pins in platform.
5. Remove gpio support since it's depend on some gpio-pxa patches in
arm-soc trees.

