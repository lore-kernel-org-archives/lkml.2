Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2HCR2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:28:05 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:40106 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2HCR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:28:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1344014855!6330328!46
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v2] staging: comedi: combine adl_pci7230 and adl_pci7432 drivers
Date: Fri, 3 Aug 2012 10:27:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208031027.47515.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers are very similar and only differ in the total number
of di/do channels provided. Combine them into one common driver to
make it more maintainable.

v2: remove the adl_pci7230 and adl_pci7432 drivers from the Kconfig
    and Makefile

H Hartley Sweeten (2):
  staging: comedi: new adl_pci7x3x driver
  staging: comedi: remove adl_pci7230 and adl_pci7432 drivers

 drivers/staging/comedi/Kconfig               |  19 +-
 drivers/staging/comedi/drivers/Makefile      |   3 +-
 drivers/staging/comedi/drivers/adl_pci7230.c | 190 ---------------
 drivers/staging/comedi/drivers/adl_pci7432.c | 200 ----------------
 drivers/staging/comedi/drivers/adl_pci7x3x.c | 342 +++++++++++++++++++++++++++
 5 files changed, 350 insertions(+), 404 deletions(-)
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7230.c
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7432.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci7x3x.c

-- 
1.7.11

