Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2HOBVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:21:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:6676 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2HOBVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:21:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1344993703!6424884!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] staging: comedi: dyna_pci10xx: update driver
Date: Tue, 14 Aug 2012 18:21:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141821.35395.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the dyna_pci10xx driver to use the PCI Pnp auto config mechanism
of the comedi core and remove the unneeded boardinfo code.

H Hartley Sweeten (7):
  staging: comedi: dnya_pci10xx: remove thisboard and devpriv macros
  staging: comedi: dnya_pci10xx: use attach_pci callback
  staging: comedi: dnya_pci10xx: cleanup the analog output range
  staging: comedi: dnya_pci10xx: remove unused fields in the boardinfo
  staging: comedi: dnya_pci10xx: move boardinfo values into subdevice
    setup
  staging: comedi: dnya_pci10xx: remove unneeded boardinfo code
  staging: comedi: dnya_pci10xx: remove unused DRV_NAME

 drivers/staging/comedi/drivers/dyna_pci10xx.c | 161 +++++++-------------------
 1 file changed, 41 insertions(+), 120 deletions(-)

-- 
1.7.11

