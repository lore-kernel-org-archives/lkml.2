Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2KIG4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 01:56:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42838 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2KIG4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 01:56:06 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-40-509ca9043ece
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] PCI: Fix bit definitions of PCI_EXP_LNKCAP2 register
Date: Fri, 09 Nov 2012 15:56:03 +0900
Message-id: <000001cdbe47$48f5dbc0$dae19340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2+R0jLYJX/EJEqS6e8d6fmSsGsxA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI12WlXMCDF6e5bW4vGsOm8XZecfZ
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpYcOc+Y8EDrorp26eyNTA2c3YxcnJICJhInP82lxXC
	FpO4cG89WxcjF4eQwDJGicPt39lhin7Ovc8CkVjEKPH/6BdWCOcXo8TveVsYQarYBNQkvnw5
	DNYhIqApMXvFFqYuRg4OZoFEiVM7qkBMYQFXiabmZJAKFgFVidlnp4B18grYSrxtP8UMYQtK
	/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQMRIC6hKP/uqCmCICehLr/7hBVIhI7HvxjhFiuoDE
	t8mHWCCqZSU2HWCGeGQyu0Tnl0gIW1Li4IobLBMYxWYh2TsLyd5ZSPbOQrJhASPLKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYyQaJHawbiyweIQowAHoxIPb+KD2QFCrIllxZW5hxglOJiV
	RHjnZs4JEOJNSaysSi3Kjy8qzUktPsToA3T4RGYp0eR8YCTnlcQbGhubmJmYmphbmpqb4hBW
	Eudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cCoV+ThcPzPXZunmyT3uDNcr70455v83xWJsvHN
	Nxx57uUqGTLMetLmVf4tZip751XVZ1l5Txcslq7nnu2qU+h4pVbIkPHoQ07d+fqd1y1bvwp0
	e+XMmbxvsZKEjnQfy2dW3j7t7MKkQywb/JrWJbIaNEXOXm1y7Kpkwif5CK3e4N+lrAxqM5RY
	ijMSDbWYi4oTAVJDgyDDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAV2WlXMCDBZv4bK4vGsOm8XZecfZ
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWHDnPmPBA66K
	6dunsjUwNnN2MXJySAiYSPyce58FwhaTuHBvPVsXIxeHkMAiRon/R7+wQji/GCV+z9vCCFLF
	JqAm8eXLYXYQW0RAU2L2ii1MXYwcHMwCiRKndlSBmMICrhJNzckgFSwCqhKzz04B6+QVsJV4
	236KGcIWlPgx+R7YXmYBLYn1O48zQdjyEpvXvGUGGSMhoC7x6K8uiCkioCex/o8bRIWIxL4X
	7xgnMArMQjJoFpJBs5AMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Gh8JrWD
	cWWDxSFGAQ5GJR7exAezA4RYE8uKK3MPMUpwMCuJ8M7NnBMgxJuSWFmVWpQfX1Sak1p8iNEH
	6M+JzFKiyfnARJFXEm9obGJmZGlkZmFkYm6OQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dU
	A+PMQMusJ4GC/gHX1f1CZOaYV9i81t7PrX6wSnXR3tzo5OUnBbrdmjY2sEstfudyzb72qOZt
	xcTWA+IqEnMuOKs9vMP44dBOW9ufD7q/bPtm91+s+cavawfORDT80N/dIDj1yaH/jbv3JbYk
	q6vrfzYS2yd65k3+yu4tH+MkH7jw3Xz42mDmtSVKLMUZiYZazEXFiQBjQ7Sp8wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the PCIe 3.0 spec, PCI_EXP_LNKCAP2_SLS_2_5GB is
1st bit of PCI_EXP_LNKCAP2 register, not 0th bit. So, the bit
definition of supported link speed vector should be fixed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/uapi/linux/pci_regs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 20ae747..14a3184 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -544,9 +544,9 @@
 #define  PCI_EXP_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
 #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints end here */
 #define PCI_EXP_LNKCAP2		44	/* Link Capability 2 */
-#define  PCI_EXP_LNKCAP2_SLS_2_5GB 0x01	/* Current Link Speed 2.5GT/s */
-#define  PCI_EXP_LNKCAP2_SLS_5_0GB 0x02	/* Current Link Speed 5.0GT/s */
-#define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x04	/* Current Link Speed 8.0GT/s */
+#define  PCI_EXP_LNKCAP2_SLS_2_5GB 0x02	/* Current Link Speed 2.5GT/s */
+#define  PCI_EXP_LNKCAP2_SLS_5_0GB 0x04	/* Current Link Speed 5.0GT/s */
+#define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x08	/* Current Link Speed 8.0GT/s */
 #define  PCI_EXP_LNKCAP2_CROSSLINK 0x100 /* Crosslink supported */
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
 #define PCI_EXP_LNKSTA2		50	/* Link Status 2 */
-- 
1.7.1


