Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab1KRWxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:53:35 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63334 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab1KRWxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:53:34 -0500
Date: Fri, 18 Nov 2011 23:53:16 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: greg@kroah.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: [PATCH] usb: dwc3: fix a warning
Message-ID: <20111118225316.GA5697@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20111118194843.GA17915@kroah.com>
References: <20111118194843.GA17915@kroah.com>
  <20111118002049.GA24806@mail.gnudd.com>
  <20111118135143.GA1101@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch left an unused variable, I apologize.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
---
 drivers/usb/dwc3/debugfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index d9e7a26..fcfa915 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -377,7 +377,6 @@ static const struct debugfs_reg32 dwc3_regs[] = {
 static int dwc3_regdump_show(struct seq_file *s, void *unused)
 {
 	struct dwc3		*dwc = s->private;
-	int			i;
 
 	seq_printf(s, "DesignWare USB3 Core Register Dump\n");
 	debugfs_print_regs32(s, dwc3_regs, ARRAY_SIZE(dwc3_regs),
-- 
1.5.6.5
