Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2FMWlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:41:22 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:39691 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2FMWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:41:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1339627269!4566110!15
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/15] staging: comedi: cleanup the 8255 driver
Date: Wed, 13 Jun 2012 15:40:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131540.51112.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup  the comedi 8255 driver.

H Hartley Sweeten (15):
  staging: comedi: 8255: replace printk calls
  staging: comedi: 8255: use pointer to dev->subdevices
  staging: comedi: 8255: rename the private data structure
  staging: comedi: 8255: remove the s->private access macros
  staging: comedi: 8255: rename cb_arg and cb_func
  staging: comedi: 8255: push out the 8255's private data variable rename
  staging: comedi: 8255: refactor subdev_8255_init
  staging: comedi: 8255: remove have_irg and refactor subdev_8255_init_irq
  staging: comedi: 8255: check for failure of subdev_8255_init
  staging: comedi: 8255: use kzalloc to allocate the private data
  staging: comedi: 8255: use a local variable for the iobase
  staging: comedi: 8255: refactor subdev_8255_insn function
  staging: comedi: 8255: move the subdev_8255_io function
  staging: comedi: 8255: add namespace to 'do_config' function
  staging: comedi: 8255: add some whitespace to the #define's

 drivers/staging/comedi/drivers/8255.c |  194 +++++++++++++++++---------------
 drivers/staging/comedi/drivers/8255.h |    8 +-
 2 files changed, 107 insertions(+), 95 deletions(-)

-- 
1.7.7

