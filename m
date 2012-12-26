Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2LZMXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:23:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29049 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2LZMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:23:39 -0500
X-AuditID: cbfee61b-b7f616d00000319b-40-50daec496b69
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        sylvester.nawrocki@gmail.com, thomas.abraham@linaro.org,
        t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v4] usb: phy: samsung: Add support to set pmu isolation
Date: Wed, 26 Dec 2012 17:58:31 +0530
Message-id: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkWtfzza0Ag74TyhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZUyaIlbQw1/x8O5j9gbGFTxdjJwcEgImEsc3
	fmKDsMUkLtxbD2YLCSxllFi+Jw+m5tbyNqYuRi6g+CJGiTXb9jJ2MXIAOZOZJGYJgdSwCehK
	NL3dxQhiiwjIShy+8psZpJ5Z4B2zRPeut8wgCWEBd4kjO0+wg9gsAqoSLS272UDm8ALF/99Q
	g9ilIPHm9jNmiBIBiW+TD7GAlEgAzdx0AGykhMAJNol5M3YyQdRLShxccYNlAqPgAkaGVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxiBAXb63zPpHYyrGiwOMQpwMCrx8HL+uhkgxJpYVlyZ
	e4hRgoNZSYRXYdWtACHelMTKqtSi/Pii0pzU4kOMPkCXTGSWEk3OBwZ/Xkm8obGJuamxqaWR
	kZmpKQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2MG+yVDli0P3j+5GX9lvdqvclHxK5O
	ndNbKq4VYtzp0PaU78e16enKuY0fwh6Zeu7YlWt6a1dhvPrUvJApU+eYKM/T2XUxYz+/b7PH
	pN4lWpdjsu9KerHO8hE7IhYg1v+rUfDy8vt/3Pf7+/V/EnKWvXRjj6jV/2Xpv070Zi1PtJMX
	fhDq/9JeiaU4I9FQi7moOBEApXo3mF0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAV3PN7cCDF6eFra4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj0hSx
	gh7+iod3H7M3MK7g6WLk5JAQMJG4tbyNCcIWk7hwbz1bFyMXh5DAIkaJNdv2MnYxcgA5k5kk
	ZgmB1LAJ6Eo0vd3FCGKLCMhKHL7ymxmknlngHbNE9663zCAJYQF3iSM7T7CD2CwCqhItLbvZ
	QObwAsX/31CD2KUg8eb2M+YJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH8DPp
	HYyrGiwOMQpwMCrx8HL+uhkgxJpYVlyZe4hRgoNZSYRXYdWtACHelMTKqtSi/Pii0pzU4kOM
	PkDLJzJLiSbnA6MrryTe0NjE3NTY1NLEwsTMEoewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5O
	qQbGBCvDvWpTBfbY2/GcMONzm7uzpPl7XPxC6akzbZqi/+2s0tF+Xv2q+cSXJVEep6Jdu69K
	Sep2app6z2T/XV599u+ibG++m562lTIffx5ovWMb/uDjsZdGq4vfPFKub7XcbmOnw30tMuX6
	7Rtuex/tmHL15cHZnxdvc2WUmXC9+Vi66cXtjx87KLEUZyQaajEXFScCAHOyopuNAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes form v3:
 - Removing the hostphy_en_mas since this gets used in forthcoming patches
   only when host phy support is added.
 - Resolving few nits:
	- using 'const' specifier for driver data structures.
	- using ARRAY_SIZE() instead of giving magic number
	  for of_property_read_u32_array()

Changes from v2:
 - Removed the phandle type of device node properties, instead using
   sub-nodes now.
 - Removed the property 'samsung,enable-mask' since it is SoC dependent
   (SoCs like S5PV210 and S3C64XX have different bits to enable/disable
   phy controller in comparison to exysno4210 onwards).
 - Maintaining the phy enable mask (which is SoC dependent) for device type phy
   and host type phy in the driver data.
 - Re-structuring to get device properties using sub-nodes for 'usbphy-pmu'

Changes from v1:
 - Changed the name of property for phy handler from'samsung,usb-phyctrl'
   to 'samsung,usb-phyhandle' to make it look more generic.
 - Similarly 'samsung,phyctrl-reg' is changed to 'samsung,phyhandle-reg'
 - Added a check for 'samsung,usb-phyhandle' before getting node from
   phandle.
 - Putting the node using 'of_node_put()' which had been missed.
 - Adding necessary check for the pointer in 'samsung_usbphy_set_isolation()'
   to avoid any NULL pointer dereferencing.
 - Unmapping the register ioremapped in 'samsung_usbphy_parse_dt_param()'.

Based on usb-next branch with Praveen Paneri's patches on top of it.
- http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/134476.html
- http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/131763.html

Vivek Gautam (1):
  usb: phy: samsung: Add support to set pmu isolation

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   31 ++++
 drivers/usb/phy/samsung-usbphy.c                   |  145 +++++++++++++++++---
 2 files changed, 155 insertions(+), 21 deletions(-)

-- 
1.7.6.5

