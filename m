Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2FYWOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:14:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:61208 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab2FYWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:14:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1340662442!7784211!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/33] staging: comedi: cb_das16_cs: cleanup the driver
Date: Mon, 25 Jun 2012 15:13:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251513.46905.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the comedi cb_das16_cs driver.

H Hartley Sweeten (33):
  staging: comedi: cb_das16_cs: remove CONFIG_PCMCIA check
  staging: comedi: cb_das16_cs: move the MODULE_* stuff to the EOF
  staging: comedi: cb_das16_cs: add module_{init,exit} declarations
  staging: comedi: cb_das16_cs: consolidate the init and exit functions
  staging: comedi: cb_das13_cs: change driver registration order
  staging: comedi: cb_das16_cs: cleanup to the pcmcia_driver declaration
  staging: comedi: cb_das16_cs: remove some useless comments
  staging: comedi: cb_das16_cs: refactor the pcmcia support code
  staging: comedi: cb_das16_cs: refactor the pcmcia attach/detach
  staging: comedi: cb_das16_cs: remove unused pcmcia 'stop' logic
  staging: comedi: cb_das16_cs: remove the pcmcia suspend/resume
  staging: comedi: cb_das16_cs: remove unneeded pcmcia private data
  staging: comedi: cb_das16_cs: Move the comedi_driver variable
  staging: comedi: cb_das16_cs: refactor the comedi attach/detach
  staging: comedi: cb_das16_cs: remove thisboard and devpriv macros
  staging: comedi: cb_das16_cs: remove n_boards define
  staging: comedi: cb_das16_cs: remove skel driver cut-and-past comments
  staging: comedi: cb_das16_cs: remove unused timer subdevice
  staging: comedi: cb_das16_cs: cleanup dio subdevice initialization
  staging: comedi: cb_das16_cs: fix analog outputo subdevice init
  staging: comedi: cb_das16_cs: remove unneeded include
  staging: comedi: cb_das16_cs: probe for the device first
  staging: comedi: cb_das16_cs: remove the debug output of the "fingerprint"
  staging: comedi: cb_das16_cs: cleanup the boardinfo
  staging: comedi: cb_das16_cs: consolidate the attach messages
  staging: comedi: cb_das16_cs: return '0' for successful attach
  staging: comedi: cb_das16_cs: add whitespace to the subdev init
  staging: comedi: cb_das16_cs: cleanup das16cs_ai_rinsn()
  staging: comedi: cb_das16_cs: use #define'd io reg offsets
  staging: comedi: cb_das16_cs: remove unused variable in private data
  staging: comedi: cb_das16_cs: use the BIP_RANGE helper macro
  staging: comedi: cb_das16_cs: remove some commented out debug
  staging: comedi: cb_das16_cs: fix a multi-line comment

 drivers/staging/comedi/drivers/cb_das16_cs.c | 575 +++++++++------------------
 1 file changed, 184 insertions(+), 391 deletions(-)

-- 
1.7.11

