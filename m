Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2FZDdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab2FZDdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:33:44 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 14/16] x86/PCI: adjust section annotations for
	'pcibios_setup()'
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 21:32:32 -0600
Message-ID: <20120626033232.16434.54284.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pcibios_setup() consistently use the "__init" section annotation.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/x86/pci/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 0ad990a..720e973 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -494,7 +494,7 @@ int __init pcibios_init(void)
 	return 0;
 }
 
-char * __devinit  pcibios_setup(char *str)
+char * __init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;

