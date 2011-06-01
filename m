Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162645Ab1FAIqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:46:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162578Ab1FAIWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:22:11 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:38 2011
Message-Id: <20110601081137.495599457@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:50 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees.cook@canonical.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [080/165] x86, cpufeature: Update CPU feature RDRND to RDRAND
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1484
Lines: 34

From: Kees Cook <kees.cook@canonical.com>

commit 7ccafc5f75c87853f3c49845d5a884f2376e03ce upstream.

The Intel manual changed the name of the CPUID bit to match the
instruction name. We should follow suit for sanity's sake. (See Intel SDM
Volume 2, Table 3-20 "Feature Information Returned in the ECX Register".)

[ hpa: we can only do this at this time because there are currently no CPUs
  with this feature on the market, hence this is pre-hardware enabling.
  However, Cc:'ing stable so that stable can present a consistent ABI. ]

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Link: http://lkml.kernel.org/r/20110524232926.GA27728@outflux.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -125,7 +125,7 @@
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
 #define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
-#define X86_FEATURE_RDRND	(4*32+30) /* The RDRAND instruction */
+#define X86_FEATURE_RDRAND	(4*32+30) /* The RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */


