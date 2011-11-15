Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab1KOXVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:21:39 -0500
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:33916 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756664Ab1KOXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:21:38 -0500
X-Greylist: delayed 13393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 18:21:38 EST
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 1/1] net/cadence: enable by default NET_ATMEL
Date: Tue, 15 Nov 2011 20:36:30 +0100
Message-Id: <1321385790-15056-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 13811977108801039128
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -89
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrtdegucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnehjucdnkihjvgculddqhedmneduuchrrghnughomhcushhtrhhinhhgldhsmdculdduiedm
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -105
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnehjucdnkihjvgculddqhedm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so the defconfig of the atmel continue to have the support of the network
as before

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi David,

	can we have this for the 3.2 so the atmel continue to work as before

Best Regards,
J.
 drivers/net/ethernet/cadence/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 98849a1..b48378a 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -7,6 +7,7 @@ config HAVE_NET_MACB
 
 config NET_ATMEL
 	bool "Atmel devices"
+	default y
 	depends on HAVE_NET_MACB || (ARM && ARCH_AT91RM9200)
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
-- 
1.7.7

