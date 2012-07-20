Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2GTRbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:31:35 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:38898 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2GTRbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:31:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1342805488!14922250!9
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] staging: comedi: fix issues with the pci_dev patchset
Date: Fri, 20 Jul 2012 10:31:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207201031.21445.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patchset to store the pci_dev in the comedi_device had a couple
issues pointed out by Ian Abbott. This patchset addresses all of
them except checking the "bustype" in the detach of the amplc drivers.
Ian is going to address those.

H Hartley Sweeten (5):
  staging: comedi: remove pci_is_enabled() tests
  staging: comedi: daqboard2000: add back subsystem_device check
  staging: comedi: daqboard2000: ioremap'ed addresses are resource_size_t
  staging: comedi: dt3000: ioremap'ed addresses are resource_size_t
  staging: comedi: rtd520: ioremap'ed addresses are resource_size_t

 drivers/staging/comedi/drivers/adv_pci1710.c  |  3 ---
 drivers/staging/comedi/drivers/adv_pci1723.c  |  2 --
 drivers/staging/comedi/drivers/adv_pci_dio.c  |  2 --
 drivers/staging/comedi/drivers/daqboard2000.c | 17 +++++++++--------
 drivers/staging/comedi/drivers/dt3000.c       |  6 ++++--
 drivers/staging/comedi/drivers/rtd520.c       | 26 ++++++++++----------------
 6 files changed, 23 insertions(+), 33 deletions(-)

-- 
1.7.11

