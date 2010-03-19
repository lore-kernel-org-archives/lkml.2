Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0CSPUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:20:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:30116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0CSPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xIsHteEqY7NERmLimxMqvZJ6yVfmgKHCCGp5CXt1EsRxFw0yQ76RR9r8GRQ00dhsHJ
         mTWM6AqSpumRQO4tCONUzIiOT3xD1exo3CBoYnSeCy7V6FJ7XVIhZtIQTJCRAHh5kaLu
         iCSPwkefbDKDALqe5mJzz/2uPk0lBhSArvhok=
Message-ID: <4BA3963D.5000001@googlemail.com>
Date: Fri, 19 Mar 2010 16:20:29 +0100
From: Frank Schaefer <fschaefer.oss@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RESEND] x86: add HPET-quirk for nVidia MCP61 LPC Bridge (10de:03e0)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this patch ? (N)Ack ? Wrong list ?




x86: add HPET-quirk for nVidia MCP61 LPC Bridge (10de:03e0)

Tested with an ASUS M2N-VM DH (nForce 430 + GeForce 6150SE).

Cc: stable@kernel.org
Signed-off-by: Frank Schaefer <fschaefer.oss@googlemail.com>
---
 arch/x86/kernel/quirks.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 12e9fea..7985ba5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -450,23 +450,25 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0051,
             nvidia_force_enable_hpet);
 
 /* LPC bridges */
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0260,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0260,    /* MCP51 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0362,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0362,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0363,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0363,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0364,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0364,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0365,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0365,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0366,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0366,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,    /* MCP55 */
+            nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x03e0,    /* MCP61 */
             nvidia_force_enable_hpet);
 
 void force_hpet_resume(void)
-- 
1.6.0.2


