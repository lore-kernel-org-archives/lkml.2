Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab2GCBKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:10:05 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:6236 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2GCBKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:10:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1341277802!7592485!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] staging: comedi: dmm32at: cleanup driver
Date: Mon, 2 Jul 2012 18:09:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021809.51710.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the dmm32at driver.

H Hartley Sweeten (8):
  staging: comedi: dmm32at: use module_comedi_driver
  staging: comedi: dmm32at: remove forward declarations 1
  staging: comedi: dmm32at: remove forward declarations 2
  staging: comedi: dmm32at: remove dmm_inb macro
  staging: comedi: dmm32at: remove dmm_outb macro
  staging: comedi: dmm32at: remove unneeded boardinfo variables
  staging: comedi: dmm32at: remove devpriv macro
  staging: comedi: dmm32at: remove skel driver cut-and-paste comments

 drivers/staging/comedi/drivers/dmm32at.c | 611 ++++++++++++-------------------
 1 file changed, 235 insertions(+), 376 deletions(-)

-- 
1.7.11

