Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2FZO1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:27:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53444 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab2FZO12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:27:28 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Li Yang <leoli@freescale.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Roland Stigge <stigge@antcom.de>
Subject: [PATCH 0/5] Usb gadget devicetree bindings
Date: Tue, 26 Jun 2012 11:27:08 -0300
Message-Id: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support to set basic usb gadget properties via
devicetree.

I takes into account the sugestions from Rob Herring and Mitch Bradley.

This was only tested on ARM LPC32XX SOC. I'm including patches to other soc's as
an reference.

Alexandre Pereira da Silva (5):
  usb: gadget: lpc32xx_udc: Propagate devicetree to gadget drivers
  usb: gadget: s3c-hsotg: Propagate devicetree to gadget drivers
  usb: gadget: fsl_udc: Propagate devicetree to gadget drivers
  usb: gadget: at91_udc: Propagate devicetree to gadget drivers
  usb: gadget: composite: parse dt overrides

 Documentation/devicetree/bindings/usb/gadget.txt |   20 +++++++++++
 drivers/usb/gadget/at91_udc.c                    |    1 +
 drivers/usb/gadget/composite.c                   |   39 ++++++++++++++++++++++
 drivers/usb/gadget/fsl_udc_core.c                |    1 +
 drivers/usb/gadget/lpc32xx_udc.c                 |    1 +
 drivers/usb/gadget/s3c-hsotg.c                   |    1 +
 6 files changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/gadget.txt

-- 
1.7.10

