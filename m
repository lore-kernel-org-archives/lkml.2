Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1FMHQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 03:16:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63685 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1FMHQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 03:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W8a6synXwNUT5yPst8RFwu1Y6eNk9FrA+VFGm+v/BqKUAYJ1Tmt5ZKXJ8r2DBJ5aDj
         L8XI1W9BEVz0j+DlHJU0+qrMwcUyTn5gItk2zb83u1dR2zuow397I4sPDqPaSVfyQy9C
         T05AlAe3QL1brTuVQLJXBmUUgrT1e4FoOZ09k=
Date: Mon, 13 Jun 2011 12:59:43 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
        pshah.mumbai@gmail.com
Subject: [PATCH 2/2] Staging: comedi: add dyna_pci10xx driver to Makefile
Message-ID: <20110613072943.GA7379@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dyna_pci10xx entry to comedi Kconfig and Makefile

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/comedi/Kconfig          |   10 ++++++++++
 drivers/staging/comedi/drivers/Makefile |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 1502d80..df1ac0a 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -820,6 +820,16 @@ config COMEDI_DT3000
 	  To compile this driver as a module, choose M here: the module will be
 	  called dt3000.
 
+config COMEDI_DYNA_PCI10XX
+	tristate "Dynalog PCI DAQ series support"
+	default N
+	---help---
+	  Enable support for Dynalog PCI DAQ series
+	  PCI-1050
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called dyna_pci10xx.
+
 config COMEDI_UNIOXX5
 	tristate "Fastwel UNIOxx-5 analog and digital io board support"
 	default N
diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
index 354fb7d..33bf1f5 100644
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_COMEDI_AMPLC_PCI224)	+= amplc_pci224.o
 obj-$(CONFIG_COMEDI_AMPLC_PCI230)	+= amplc_pci230.o
 obj-$(CONFIG_COMEDI_CONTEC_PCI_DIO)	+= contec_pci_dio.o
 obj-$(CONFIG_COMEDI_DT3000)		+= dt3000.o
+obj-$(CONFIG_COMEDI_DYNA_PCI10XX)	+= dyna_pci10xx.o
 obj-$(CONFIG_COMEDI_UNIOXX5)		+= unioxx5.o
 obj-$(CONFIG_COMEDI_GSC_HPDI)		+= gsc_hpdi.o
 obj-$(CONFIG_COMEDI_ICP_MULTI)		+= icp_multi.o
-- 
1.7.1

