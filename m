Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2ITRBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:01:22 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:49772 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2ITRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:01:21 -0400
From: ciminaghi@gnudd.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com
Cc: giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 2/2] x86, pci sta2x11-fixup: add function to access sta2x11 instance id.
Date: Thu, 20 Sep 2012 18:44:09 +0200
Message-Id: <1348159449-21583-3-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com>
References: <1348159449-21583-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The sta2x11 instance id will be included in clock names to make them
unique in case of multiple sta2x11's living on the same machine.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 arch/x86/pci/sta2x11-fixup.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 478c228..6450853 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -138,6 +138,12 @@ struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(sta2x11_get_instance);
 
+int sta2x11_get_instance_id(struct sta2x11_instance *instance)
+{
+	return instance->bus0;
+}
+EXPORT_SYMBOL(sta2x11_get_instance_id);
+
 
 /**
  * p2a - Translate physical address to STA2x11 AMBA address,
-- 
1.7.9.1

