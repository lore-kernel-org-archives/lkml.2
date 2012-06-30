Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2F3Ae0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:34:26 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:19957 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2F3AeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:34:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1341016463!6151991!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/10] staging: comedi: ni_670x: cleanup driver
Date: Fri, 29 Jun 2012 17:34:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291734.19249.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the driver based on the changes to the other comedi
pci drivers.

H Hartley Sweeten (10):
  staging: comedi: ni_670x: use module_comedi_pci_driver
  staging: comedi: ni_670x: remove forward declarations
  staging: comedi: ni_670x: remove thisboard and devpriv macros
  staging: comedi: ni_670x: remove n_ni_670x_boards macro
  staging: comedi: ni_670x: change printk's to cleaned up dev_printk's
  staging: comedi: ni_670x: return '0' for successful attach
  staging: comedi: ni_670x: fix dereference of an invalid pointer
  staging: comedi: ni_670x: cleanup the boardinfo
  staging: comedi: ni_670x: cleanup ni_670x_dio_insn_bits()
  staging: comedi: ni_670x: remove unused 'ao_bits'

 drivers/staging/comedi/drivers/ni_670x.c | 348 ++++++++++++++-----------------
 1 file changed, 156 insertions(+), 192 deletions(-)

-- 
1.7.11

