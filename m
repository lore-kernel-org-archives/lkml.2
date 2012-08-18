Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2HRBEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:04:40 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:49578 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2HRBEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:04:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1345251867!8735955!21
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/20] staging: comedi: update comedi pci drivers part 2
Date: Fri, 17 Aug 2012 18:04:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171804.21948.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another round of updates to the comedi pci drivers.

* remove function trace messages
* remove devpriv and thisboard type macros
* cleanup the boardinfo
* remove forward declarations
* use attach_pci and remove legacy attach (when possible)
* misc. other changes

H Hartley Sweeten (20):
  staging: comedi: adv_pci1710: remove function trace messages
  staging: comedi: adv_pci1710: remove devpriv and this_board macros
  staging: comedi: adv_pci1710: convert boardinfo initialization to C99 format
  staging: comedi: adv_pci1710: remove '0' and 'NULL' boardinfo data
  staging: comedi: adv_pci1710: remove forward declarations
  staging: comedi: adv_pci1723: remove function trace messages
  staging: comedi: adv_pci1723: remove devpriv and this_board macros
  staging: comedi: adv_pci1723: remove range_pci1723
  staging: comedi: adv_pci1723: fix initial dio subdevice state and io_bits
  staging: comedi: adv_pci1723: remove boardinfo
  staging: comedi: adv_pci1723: use attach_pci callback
  staging: comedi: adv_pci1723: cleanup card reset
  staging: comedi: adv_pci_dio: remove function trace messages
  staging: comedi: adv_pci_dio: remove devpriv and this_board macros
  staging: comedi: adv_pci_dio: use attach_pci callback
  staging: comedi: adv_pci_dio: convert boardinfo initialization to C99 format
  staging: comedi: adv_pci_dio: remove '0' boardinfo data
  staging: comedi: adv_pci_dio: add the number of subdevices to the boardinfo
  staging: comedi: adv_pci_dio: simplify the 'detach'
  staging: comedi: adv_pci_dio: fix bug in 'detach'

 drivers/staging/comedi/drivers/adv_pci1710.c | 590 +++++++++++++--------------
 drivers/staging/comedi/drivers/adv_pci1723.c | 222 +++-------
 drivers/staging/comedi/drivers/adv_pci_dio.c | 428 +++++++++----------
 3 files changed, 535 insertions(+), 705 deletions(-)

-- 
1.7.11

