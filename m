Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab2HIVuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:50:21 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:65122 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab2HIVuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:50:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1344549002!6957596!19
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] staging: comedi: update the adl_pci6208 driver
Date: Thu, 9 Aug 2012 14:50:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208091450.05873.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the comedi adl_pci6208 pci driver.

H Hartley Sweeten (4):
  staging: comedi: adl_pci6208: use attach_pci callback
  staging: comedi: adl_pci6208: add support for the PCI-6216 card
  staging: comedi: adl_pci6208: split the digital i/o subdevice
  staging: comedi: adl_pci6208: use the 'board_name' for the resource name

 drivers/staging/comedi/drivers/adl_pci6208.c | 187 ++++++++++++++-------------
 1 file changed, 94 insertions(+), 93 deletions(-)

-- 
1.7.11

