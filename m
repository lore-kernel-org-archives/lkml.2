Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2FSXTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:19:52 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:26453 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FSXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:19:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1340147990!5823648!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/5] staging: comedi: Kconfig cleanup
Date: Tue, 19 Jun 2012 16:19:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206191619.39018.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the comedi Kconfig.

v2: fix the 'depends on' for the 8255 driver

H Hartley Sweeten (5):
  staging: comedi: Kconfig: fix drivers that require the 8255 driver
  staging: comedi: remove unused CONFIG_COMEDI_PCMCIA define
  staging: comedi: remove CONFIG_COMEDI_PCI define
  staging: comedi: Kconfig: menuconfig options should be bool
  staging: comedi: Kconfig: remove redundant depends on tests

 drivers/staging/comedi/Kconfig          | 15 ++++++---------
 drivers/staging/comedi/comedidev.h      | 13 -------------
 drivers/staging/comedi/drivers/Makefile |  1 -
 drivers/staging/comedi/drivers/skel.c   |  2 +-
 4 files changed, 7 insertions(+), 24 deletions(-)

-- 
1.7.11

