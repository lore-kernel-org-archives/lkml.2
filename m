Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950Ab2K2FGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:06:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12139 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2K2FGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:06:18 -0500
X-AuditID: cbfee61b-b7f616d00000319b-86-50b6ed48a470
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-i2c@vger.kernel.org
Cc: naveen@chromium.org, sjg@chromium.org, grundler@chromium.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] i2c-s3c2410: Implementation bus arbitration support
Date: Thu, 29 Nov 2012 10:35:33 +0530
Message-id: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkStfj7bYAg2OzjSw6/n5htLi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgypg6W6rgFHPFz77DrA2Mj5m6GDk5JARMJM7d
	bGSFsMUkLtxbz9bFyMUhJLCUUWJbzzpmmKLDbxtZIBKLGCU+LVjOCOH0MEn0f1vOBlLFJmAm
	cXDRanYQW0QgQ2LJow2MIDazQLnEp0fbwVYIC3hI7Hj2DWwqi4CqxLm7r8F6eQVcJc5uawPq
	5QDapiAxZ5INRImAxLfJh1ggwrISmw4wg6yVEDjCJrF7y1kWiOMkJQ6uuMEygVFwASPDKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzAIDv975n0DsZVDRaHGAU4GJV4eDdabgsQYk0sK67M
	PcQowcGsJMJrWQ0U4k1JrKxKLcqPLyrNSS0+xOgDdMlEZinR5HxgBOSVxBsam5ibGptaGhmZ
	mZriEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwMjhNy00o0Eoqfe0p6v37rAPbg5Fm1+t
	X+OXvWfu/QtHDr3zEz7xsuVx/5Q3VdEvjtb4zN+q1sqe/EA2n/nwt+WP9TYmC6Rbvlw5YaWD
	Dl/9inWBkkWlQtJy8y+8ULqtdmIdT069UPLVEplNds319y/pff2onvWRQXCXTOWanBdKM/XD
	3L67OimxFGckGmoxFxUnAgCzijhhXwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jAV2Pt9sCDDo+qFh0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gxdbZU
	wSnmip99h1kbGB8zdTFyckgImEgcftvIAmGLSVy4t56ti5GLQ0hgEaPEpwXLGSGcHiaJ/m/L
	2UCq2ATMJA4uWs0OYosIZEgsebSBEcRmFiiX+PRoOyuILSzgIbHj2TdmEJtFQFXi3N3XYL28
	Aq4SZ7e1AfVyAG1TkJgzyWYCI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEh/Ex6
	B+OqBotDjAIcjEo8vBsttwUIsSaWFVfmHmKU4GBWEuG1rAYK8aYkVlalFuXHF5XmpBYfYvQB
	Wj6RWUo0OR8YX3kl8YbGJuamxqaWJhYmZpY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1
	MCZn/35/TqxNdcWeb7m2vT94Zsbd0dNdX6inpBR56EJcmdst9e2vlsT6lX5utjD4EZRf972s
	y5nndHeibnCebQbvZf4Ve2JC9jUv4zzS2//jg/3rvA2HrdZxMims6t9w0Pu4WfAijynmAR9l
	FTeKn162rTQo5u62YMfnEnOrRV6vZz2kZLv+ohJLcUaioRZzUXEiABaQgcuOAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for i2c bus arbitration between AP(exynos),
device(EC) in i2c-s3c2410 driver.

Simon Glass (2):
  i2c-s3c2410: Leave the bus disabled unless it is in use
  i2c-s3c2410: Add bus arbitration implementation

 .../devicetree/bindings/i2c/samsung-i2c.txt        |   46 +++++
 drivers/i2c/busses/i2c-s3c2410.c                   |  204 ++++++++++++++++++--
 2 files changed, 233 insertions(+), 17 deletions(-)

-- 
1.7.9.5

