Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2LROh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:37:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47044 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2LROh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:37:26 -0500
X-AuditID: cbfee61b-b7f616d00000319b-85-50d07fa45ce8
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        jg1.han@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com
Subject: [PATCH v5 0/4] Adding usb2.0 host-phy support for exynos5250
Date: Tue, 18 Dec 2012 20:13:02 +0530
Message-id: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkRndJ/YUAg49PzSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyrhy4jBzwT6BioufWpgbGF/xdDFyckgImEi8
	enGPBcIWk7hwbz1bFyMXh5DAUkaJyctWs8MUTe24xQxiCwlMZ5Q4ec0Somgyk8StKWcYQRJs
	AroSTW93gdkiArISh6/8ZgYpYhboZZY4dfII2AphAVeJv11vWEFsFgFViQX/WsE28Ap4SOzu
	fMIGsU1B4s3tZ8wQNQIS3yYfAurlAIrLSmw6ADZTQuAEm8SRjVOh6iUlDq64wTKBUXABI8Mq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjMBAO/3vmfQOxlUNFocYBTgYlXh4f8afDxBiTSwr
	rsw9xCjBwawkwvsm7kKAEG9KYmVValF+fFFpTmrxIUYfoEsmMkuJJucDoyCvJN7Q2MTc1NjU
	0sjIzNQUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsbGDy+O6Kw0uaLVrxrLfrpy0Xqe
	1w8u7sqrXXRwieH7uf9zLGbNXL/zsmnEYUWur3VTbko2imxLv5THcfGf0JrCOLXnMuuU3i45
	8qDstLOpf6XiYqa51VIRT9lu7Jl90nxf/7uY2WJiAnLNrxS+2PDZ52fVWpV536rNODklNPr0
	bm4ZB6/zex4osRRnJBpqMRcVJwIAroRO72ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQd0l9RcCDI59Vbe4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjyonD
	zAX7BCoufmphbmB8xdPFyMkhIWAiMbXjFjOELSZx4d56NhBbSGA6o8TJa5ZdjFxA9mQmiVtT
	zjCCJNgEdCWa3u4Cs0UEZCUOX/nNDFLELNDLLHHq5BEWkISwgKvE3643rCA2i4CqxIJ/rewg
	Nq+Ah8TuzidsENsUJN7cfsY8gZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgMH4m
	vYNxVYPFIUYBDkYlHt6f8ecDhFgTy4orcw8xSnAwK4nwvom7ECDEm5JYWZValB9fVJqTWnyI
	0Qdo+0RmKdHkfGCM5ZXEGxqbmJsam1qaWJiYWeIQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TB
	KdXAOPt2846gs0d0bebPlfE+2mbaYWTDe4nBb0HejawtKx7fbRedtfwGU2m92eKF3IVWLPO7
	V08T3fC6Q26KhM6nxLcvHXxfWgtFxW30LCtR/HPuQ8W1tfaqC812PZfOPDqx4aCEymW1Lx97
	xKMvP1jy5p6Vn2g+0zrpHKnpi/8LMDJU1T1c4jGfW4mlOCPRUIu5qDgRAB8ol0uQAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v4:
 - Moved architecture side changes out of this patch-set.
 - Added support for multiple usbphy phandle parsing and
   doing all pmu_isolation() and phy_cfg_sel() related changes
   in samsung-usbphy driver only instead of architecture
   as in v4 patch-set.
 - Removed unnecessary multi line definitions for macros.

Changes from v3:
 - Moved enums S5P_USB_PHY_DEVICE, S5P_USB_PHY_HOST from machine to file
   include/linux/usb/samsung_usb_phy.h as USB_PHY_TYPE_DEVICE and
   USB_PHY_TYPE_HOST to make it more generic. Further resolve its
   dependencies.
 - Introduced a function 'samsung_usbphy_set_type()' which takes
   care of setting up the phy_type: HOST/DEVICE. This function
   can be called by host/otg drivers to setup phy_type prior to
   handling the respective PHYs.
 - Added an error-path for HOST type phy in s5p_usb_phy_pmu_isolation()
   for 'mach-s3c64xx'.
 - Moving to PHY driver as default for ehci-s5p and ohci-exynos, and only
   when failed fall back to plat-data.
 - Added samsung_usbphy_set_type() prior to doing usb_phy_init() or
   usb_phy_shutdown() so that appropriate PHY gets init or shutdown.

Based on patches for samsung-usbphy driver:
 1)http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/134476.html
 2)https://lkml.org/lkml/2012/12/18/187
 
Vivek Gautam (4):
  ARM: EXYNOS: Update & move usb-phy types to generic include layer
  usb: phy: samsung: Add host phy support to samsung-phy driver
  USB: ehci-s5p: Add phy driver support
  USB: ohci-exynos: Add phy driver support

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   25 +-
 drivers/usb/host/ehci-s5p.c                        |   71 +++-
 drivers/usb/host/ohci-exynos.c                     |   71 +++-
 drivers/usb/phy/Kconfig                            |    2 +-
 drivers/usb/phy/samsung-usbphy.c                   |  465 ++++++++++++++++++--
 include/linux/usb/samsung_usb_phy.h                |   29 ++
 6 files changed, 570 insertions(+), 93 deletions(-)
 create mode 100644 include/linux/usb/samsung_usb_phy.h

-- 
1.7.6.5

