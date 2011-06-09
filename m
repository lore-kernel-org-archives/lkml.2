Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1FIJKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:10:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39873 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1FIJKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mqD1Jvg0mqTQUTIDdG6EwTHeJHumPvSbFkJuXjw5MqnrchjPopPesSm5n1g7IMBxdn
         36mbwhyFk4vg9NFHlb9/eRbrbYiOGqIVeT7EgCwG5ZuwEKH+XTOFf0VKl99XPLgu6FE0
         Am2bz9RDBB+nqFAFOPG9M+2jXDGmBymGBhjCM=
Date: Thu, 9 Jun 2011 14:55:02 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: add dyna_pci10xx driver to Makefile
Message-ID: <20110609092502.GA2891@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dyna_pci10xx0 entry to comedi Kconfig and Makefile

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

