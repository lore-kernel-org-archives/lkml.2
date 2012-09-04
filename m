Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab2IDW1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:27:33 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:15620 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2IDW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:27:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1346797651!6812997!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: comedi: addi-data: remove some unnecessary files
Date: Tue, 4 Sep 2012 15:27:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201209041527.22240.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a couple of the addi-data files that are either not built under any
configuration or are unnecessary due to code duplication in another file.

H Hartley Sweeten (3):
  staging: comedi: addi_apci_all.c: remove unused file
  staging: comedi: amcc_s5933_58.h: remove unused file
  staging: comedi: addi_amcc_S5920.[ch]: remove unnecessary files

 .../comedi/drivers/addi-data/addi_amcc_S5920.c     | 195 ---------
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |  27 --
 .../comedi/drivers/addi-data/amcc_s5933_58.h       | 453 ---------------------
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  12 +-
 drivers/staging/comedi/drivers/addi_apci_all.c     |  18 -
 5 files changed, 7 insertions(+), 698 deletions(-)
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_all.c

-- 
1.7.11

