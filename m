Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2FOWTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:19:50 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:31660 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2FOWTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:19:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1339798787!6872725!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] staging: comedi: cleanup Kconfig
Date: Fri, 15 Jun 2012 15:19:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206151519.35531.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the comedi Kconfig a bit.

H Hartley Sweeten (4):
  staging: comedi: Kconfig: menuconfig options should be bool not tristate
  staging: comedi: remove unused CONFIG_COMEDI_PCMCIA define
  staging: comedi: remove CONFIG_COMEDI_PCI
  staging: comedi: Kconfig: remove a couple redundant depends on tests

 drivers/staging/comedi/Kconfig        |   12 +++++-------
 drivers/staging/comedi/comedidev.h    |   13 -------------
 drivers/staging/comedi/drivers/skel.c |    2 +-
 3 files changed, 6 insertions(+), 21 deletions(-)

-- 
1.7.7

