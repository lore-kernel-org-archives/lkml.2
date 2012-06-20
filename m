Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab2FTTKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:10:42 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:60723 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2FTTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:10:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340218690!7278405!139
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] staging: comedi: cleanup comedi usb drivers
Date: Wed, 20 Jun 2012 12:00:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201200.36144.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the module_comedi_usb_driver helper macro to remove the
module init/exit boilerplate. And refactor the init code to
follow the style of the other comedi driver types and improve
maintainability.

H Hartley Sweeten (8):
  staging: comedi: usbdux: use module_comedi_usb_driver()
  staging: comedi: usbduxfast: use module_comedi_usb_driver()
  staging: comedi: usbduxsigma: use module_comedi_usb_driver()
  staging: comedi: vmk80xx: use module_comedi_usb_driver()
  staging: comedi: vmk80xx: refactor init code
  staging: comedi: usbduxsigma: refactor init code
  staging: comedi: usbduxfast: refactor init code
  staging: comedi: usbdux: refactor init code

 drivers/staging/comedi/drivers/usbdux.c      | 516 +++++++++++++--------------
 drivers/staging/comedi/drivers/usbduxfast.c  | 366 +++++++++----------
 drivers/staging/comedi/drivers/usbduxsigma.c | 477 ++++++++++++-------------
 drivers/staging/comedi/drivers/vmk80xx.c     | 107 +++---
 4 files changed, 665 insertions(+), 801 deletions(-)

-- 
1.7.11

