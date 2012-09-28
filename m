Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab2I1Mxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:53:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37795 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab2I1Mxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:53:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>
Subject: [PATCH 0/6] usb: dwc3-omap: add dt support
Date: Fri, 28 Sep 2012 18:23:09 +0530
Message-ID: <1348836795-4783-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dt support to dwc3 core and fixes few minor
stuff in dwc3-omap glue to get dwc3 working.

While at that it also uses *of_platform* to create the child device
(dwc3-core) and fixes to use runtime API's to enable clock and write
to SYSCONFIG register.

This patch series is developed on:
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git dwc3

These patches were actually tested in
http://gitorious.org/linux-usb/linux-usb/commits/dwc3 dwc3
since all the dependent modules is not yet upstreamed.

Kishon Vijay Abraham I (6):
  usb: dwc3-omap: use of_platform API to create dwc3 core pdev
  usb: dwc3-omap: use runtime API's to enable clocks
  usb: dwc3-omap: Remove explicit writes to SYSCONFIG register
  usb: dwc3-omap: Add an API to write to dwc mailbox
  usb: dwc3-omap: Minor fixes to get dt working
  usb: dwc3: core: add dt support for dwc3 core

 Documentation/devicetree/bindings/usb/dwc3.txt |   24 ++++
 drivers/usb/dwc3/core.c                        |   14 +-
 drivers/usb/dwc3/dwc3-omap.c                   |  164 ++++++++++++++----------
 include/linux/usb/dwc3-omap.h                  |   30 +++++
 4 files changed, 160 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
 create mode 100644 include/linux/usb/dwc3-omap.h

-- 
1.7.10.4

