Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2HCRIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:08:53 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:50309 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2HCRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:08:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1344013646!6343211!43
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] staging: comedi: combine adl_pci7230 and adl_pci7432 drivers
Date: Fri, 3 Aug 2012 10:08:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208031008.25345.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers are very similar and only differ in the total number
of di/do channels provided. Combine them into one common driver to
make it more maintainable.

H Hartley Sweeten (2):
  staging: comedi: new adl_pci7x3x driver
  staging: comedi: remove adl_pci7230 and adl_pci7432 drivers

 drivers/staging/comedi/Kconfig               |  11 +
 drivers/staging/comedi/drivers/Makefile      |   1 +
 drivers/staging/comedi/drivers/adl_pci7230.c | 190 ---------------
 drivers/staging/comedi/drivers/adl_pci7432.c | 200 ----------------
 drivers/staging/comedi/drivers/adl_pci7x3x.c | 342 +++++++++++++++++++++++++++
 5 files changed, 354 insertions(+), 390 deletions(-)
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7230.c
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7432.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci7x3x.c

-- 
1.7.11

