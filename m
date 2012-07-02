Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2GBWl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:41:56 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:48470 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2GBWly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:41:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1341268887!7583426!10
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/12] staging: comedi: das08_cs: cleanup driver
Date: Mon, 2 Jul 2012 15:41:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021541.21705.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the das08_cs comedi pcmcia driver.

H Hartley Sweeten (12):
  staging: comedi: das08_cs: move the MODULE_* stuff to the EOF
  staging: comedi: das08_cs: consolidate the init and exit functions
  staging: comedi: das08_cs: change driver registration order
  staging: comedi: das08_cs: cleanup the pcmcia_driver declaration
  staging: comedi: das08_cs: cleanup and remove useless comments
  staging: comedi: das08_cs: refactor the pcmcia support code
  staging: comedi: das08_cs: remove unused pcmcia 'stop' logic
  staging: comedi: das08_cs: remove the pcmcia suspend/resume
  staging: comedi: das08_cs: remove unneeded pcmcia private data
  staging: comedi: das08_cs: refactor the pcmcia probe/remove
  staging: comedi: das08_cs: move the comedi_driver variable
  staging: comedi: das08_cs: remove thisboard macro

 drivers/staging/comedi/drivers/das08_cs.c | 182 ++++++++----------------------
 1 file changed, 48 insertions(+), 134 deletions(-)

-- 
1.7.11

