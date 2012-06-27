Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2F0VvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:51:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:15332 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2F0VvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:51:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1340833875!8020760!4
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/19] staging: comedi: adl_pci6208: cleanup driver
Date: Wed, 27 Jun 2012 14:51:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271451.09262.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the adl_pci6208 comedi driver.

H Hartley Sweeten (19):
  staging: comedi: adl_pci6208: remove thisboard and devpriv macros
  staging: comedi: adl_pci6208: refactor pci6208_find_device()
  staging: comedi: adl_pci6208: remove the boardinfo 'ao_bits'
  staging: comedi: adl_pci6208: document the register map of the device
  staging: comedi: adl_pci6208: cleanup pci6208_pci_setup()
  staging: comedi: adl_pci6208: remove pci6208_pci_setup()
  staging: comedi: adl_pci6208: pass on the error code from
    comedi_pci_enable
  staging: comedi: adl_pci6208: consolidate the attach messages
  staging: comedi: adl_pci6208: fix the digital i/o subdevice
  staging: comedi: adl_pci6208: add whitespace to the subdev init
  staging: comedi: adl_pci6208: return '0' for successful attach
  staging: comedi: adl_pci6208: remove the bogus pci devices
  staging: comedi: adl_pci6208: remove some useless comments
  staging: comedi: adl_pci6208: remove unused variable in the private
    data
  staging: comedi: adl_pci6208: fix the ao_readback variable size
  staging: comedi: adl_pci6208: cleanup pci6208_ao_winsn()
  staging: comedi: adl_pci6208: cleanup pci6208_ao_rinsn()
  staging: comedi: adl_pci6208: cleanup pci6208_attach()
  staging: comedi: adl_pci6208: use the driver_name for the resource
    name

 drivers/staging/comedi/drivers/adl_pci6208.c | 372 +++++++++++----------------
 1 file changed, 149 insertions(+), 223 deletions(-)

-- 
1.7.11

