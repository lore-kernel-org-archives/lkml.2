Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2AXLq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:46:57 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54418 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753889Ab2AXLqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:46:55 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:27/51=53%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:44/51=86%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 0/9] usb: gadget: generic map/unmap routines
Date: Tue, 24 Jan 2012 13:45:21 +0200
Message-Id: <1327405543-27589-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here's a rebased version of generic map/unmap patchset.

Also available on generic-map-unmap branch of my tree, some
of the patches have been tested before and already have a
Tested-by tag.

Felipe Balbi (9):
  usb: gadget: add generic map/unmap request utilities
  usb: dwc3: gadget: use generic map/unmap routines
  usb: gadget: langwell: use generic map/unmap functions
  usb: renesas: gadget: use generic map/unmap routines
  usb: gadget: amd5536: use generic map/unmap routines
  usb: gadget: r8a66597: use generic map/unmap routines
  usb: gadget: net2272: use generic map/umap routines
  usb: gadget: net2280: use generic map/unmap routines
  usb: gadget: goku: use generic map/unmap routines

 drivers/usb/dwc3/core.h                |    2 -
 drivers/usb/dwc3/ep0.c                 |   16 +++++-
 drivers/usb/dwc3/gadget.c              |   93 ++++++--------------------------
 drivers/usb/dwc3/gadget.h              |    2 -
 drivers/usb/gadget/amd5536udc.c        |   33 ++---------
 drivers/usb/gadget/goku_udc.c          |   18 +++----
 drivers/usb/gadget/langwell_udc.c      |   45 +++-------------
 drivers/usb/gadget/net2272.c           |   18 +++----
 drivers/usb/gadget/net2280.c           |   19 +++----
 drivers/usb/gadget/r8a66597-udc.c      |   10 +---
 drivers/usb/gadget/udc-core.c          |   52 ++++++++++++++++++
 drivers/usb/renesas_usbhs/mod_gadget.c |   73 ++++++-------------------
 include/linux/usb/gadget.h             |   10 ++++
 13 files changed, 149 insertions(+), 242 deletions(-)

-- 
1.7.8.2

