Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2F0ApJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:45:09 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:22514 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F0ApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:45:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-131.messagelabs.com!1340757905!23363431!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/36] staging: comedi: cb_pcidas: cleanup the driver
Date: Tue, 26 Jun 2012 17:45:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261745.00636.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the cb_pcidas driver.

H Hartley Sweeten (36):
  staging: comedi: cb_pcidas: remove forward declarations 1
  staging: comedi: cb_pcidas: remove forward declarations 2
  staging: comedi: cb_pcidas: remove forward declarations 3
  staging: comedi: cb_pcidas: remove forward declarations 4
  staging: comedi: cb_pcidas: remove forward declarations 5
  staging: comedi: cb_pcidas: remove forward declarations 6
  staging: comedi: cb_pcidas: remove forward declarations 7
  staging: comedi: cb_pcidas: remove forward declarations 8
  staging: comedi: cb_pcidas: remove forward declarations 9
  staging: comedi: cb_pcidas: remove thisboard and devpriv macros
  staging: comedi: cb_pcidas: factor out the find pci device code
  staging: comedi: cb_pcidas: remove some obvious comments in the
    attach
  staging: comedi: cb_pcidas: remove the PCI BAR index defines
  staging: comedi: cb_pcidas: remove CB_PCIDAS_DEBUG define
  staging: comedi: cb_pcidas: remove unused io region size defines
  staging: comedi: cb_pcidas: simplify the boardinfo
  staging: comedi: cb_pcidas: cleanup the boardinfo 1
  staging: comedi: cb_pcidas: cleanup the boardinfo 2
  staging: comedi: cb_pcidas: cleanup the boardinfo 3
  staging: comedi: cb_pcidas: cleanup the boardinfo 4
  staging: comedi: cb_pcidas: cleanup ai_config_insn()
  staging: comedi: cb_pcidas: move the "find pci" dev_printk messages
  staging: comedi: cb_pcidas: use the driver_name for the resource name
  staging: comedi: cb_pcidas: check for failure of subdev_8255_init
  staging: comedi: cb_pcidas: fix a space before tab issue
  staging: comedi: cb_pcidas: fix some > 80 char lines
  staging: comedi: cb_pcidas: fix comments in *_cmdtest functions
  staging: comedi: cb_pcidas: remove 'volatile' on private data
    variables
  staging: comedi: cb_pcidas: fix comments in private data struct
  staging: comedi: cb_pcidas: change dac bit enums into defines
  staging: comedi: cb_pcidas: add whitespace to all the #define's
  staging: comedi: cb_pcidas: fix remaining checkpatch.pl issues
  staging: comedi: cb_pcidas: cleanup cb_pcidas_ao_fifo_winsn()
  staging: comedi: cb_pcidas: cleanup cb_pcidas_ao_nofifo_winsn()
  staging: comedi: cb_pcidas: cleanup cb_pcidas_ai_rinsn()
  staging: comedi: cb_pcidas: cleanup dac08_write()

 drivers/staging/comedi/drivers/cb_pcidas.c | 1695 +++++++++++++---------------
 1 file changed, 770 insertions(+), 925 deletions(-)

-- 
1.7.11

