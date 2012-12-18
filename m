Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2LRFtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:49:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35949 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LRFti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:49:38 -0500
X-AuditID: cbfee61b-b7f616d00000319b-95-50d003f08b62
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        p.paneri@samsung.com
Subject: [PATCH] usb: phy: samsung: Add support to set pmu isolation
Date: Tue, 18 Dec 2012 11:26:06 +0530
Message-id: <1355810167-18425-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkSvcD84UAg6YDehaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZfSv0S3oY6u4dGw5YwPjB5YuRk4OCQETicsX
	P7BD2GISF+6tZ+ti5OIQEljKKNF66ixTFyMHWNHif7UgNUICixgltk5lh6iZzCSx6skUZpAE
	m4CuRNPbXYwgtoiArMThK7+ZQYqYBXYySyy9188GkhAWcJH4dHQ6mM0ioCpxvmUSWDOvgIfE
	rsVdTBBXKEi8uf2MGaJGQOLb5EMsEEfISmw6ADZTQuAEm8SOmfvZIOolJQ6uuMEygVFwASPD
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzAIDv975n0DsZVDRaHGAU4GJV4eH/Gnw8QYk0s
	K67MPcQowcGsJMJ7ew1QiDclsbIqtSg/vqg0J7X4EKMP0CUTmaVEk/OBEZBXEm9obGJuamxq
	aWRkZmqKQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA6Prr0qv0O17WpmnXp3pI+htlrh8
	7tHCG4zP429mR23b7CY8XVNa4cq+CTv/y3JPqHm0Vdlaw6mmNfnJkh8apXOLe9dxPnileXqy
	sP6COREnLnm/LTgw8+W8XeY9Ly98fcy6iGuOovnfd2J7NSLOvVZN027JnMXC4CrLHaEj2lF7
	ZW3rc+8a9kAlluKMREMt5qLiRAAHdovLXwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jAd0PzBcCDLoeKFpc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRv0a3
	oI+t4tKx5YwNjB9Yuhg5OCQETCQW/6vtYuQEMsUkLtxbzwZiCwksYpTYOpW9i5ELyJ7MJLHq
	yRRmkASbgK5E09tdjCC2iICsxOErv5lBipgFdjJLLL3XD9YtLOAi8enodDCbRUBV4nzLJLBm
	XgEPiV2Lu5ggtilIvLn9jHkCI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEh/Ex6
	B+OqBotDjAIcjEo8vD/jzwcIsSaWFVfmHmKU4GBWEuG9vQYoxJuSWFmVWpQfX1Sak1p8iNEH
	aPtEZinR5HxgfOWVxBsam5ibGptamliYmFniEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnV
	wNjB7mk7zVBu9ynWKds5Lmmvma2czBySMPtqlr7MGybLlSfb7cIWffhwu4Ozzy9r5aLLcdwf
	niccWHBl5a7IC11mVoln8gxdn4TFshy+t9Rdk/XOLW3PScofE0KPet7+9T+u6tYi8fccP1qM
	2LIfVBSavj84N/HLiZbyzk0sKqYGmoEV3+vOOiixFGckGmoxFxUnAgApr+7BjgIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on patches for samsung-usbphy driver available at:
https://patchwork.kernel.org/patch/1794651/

In this patch we are adding support to parse device tree data for
samsung-usbphy driver and further setting pmu_isolation to
enable/disable phy as and when needed.
This further chucks out the need of platform data for samsung-usbphy on
DT enabled system and hence serves the purpose of the discussion
in the thread for:
[PATCH v8 2/2] usb: s3c-hsotg: Adding phy driver support

Vivek Gautam (1):
  usb: phy: samsung: Add support to set pmu isolation

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   10 +++
 drivers/usb/phy/samsung-usbphy.c                   |   80 ++++++++++++++++++--
 2 files changed, 82 insertions(+), 8 deletions(-)

-- 
1.7.6.5

