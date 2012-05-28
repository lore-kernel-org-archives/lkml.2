Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2E1D3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab2E1D3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:10 -0400
Message-Id: <20120528031204.815467775@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 014/117] arch/tile/Kconfig: remove pointless "!M386" test.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 8d6951439ef524683057251f1231df232046b6b6 upstream.

Looks like a cut and paste bug from the x86 version.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 11270ca..30413c1 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -12,7 +12,7 @@ config TILE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
-	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT


