Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1LLD3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:13 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:48382
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab1LLD2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:45 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Steven Miao <realmz6@gmail.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 11/11] blackfin: mac: dsa: add vlan mask in board file
Date: Mon, 12 Dec 2011 11:28:33 +0800
Message-ID: <1323660513-9620-11-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

Else push file through ftp/rcp will fail.

Signed-off-by: Steven Miao <realmz6@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index c4de8f9..a2d96d3 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -122,6 +122,8 @@ static struct bfin_mii_bus_platform_data bfin_mii_bus_data = {
 #if defined(CONFIG_NET_DSA_KSZ8893M) || defined(CONFIG_NET_DSA_KSZ8893M_MODULE)
 	.phy_mask = 0xfff7, /* Only probe the port phy connect to the on chip MAC */
 #endif
+	.vlan1_mask = 1,
+	.vlan2_mask = 2,
 };
 
 static struct platform_device bfin_mii_bus = {
-- 
1.7.0.4


