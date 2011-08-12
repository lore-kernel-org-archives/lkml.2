Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1HNQJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab1HNQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.331411738@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [71/90] sparc: Add some missing hypervisor API groups.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit e2eb9f8158ead43a88c0f0b4d74257b1be938a18 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/hypervisor.h |    6 ++++++
 arch/sparc/kernel/hvapi.c           |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/arch/sparc/include/asm/hypervisor.h
+++ b/arch/sparc/include/asm/hypervisor.h
@@ -2940,11 +2940,17 @@ extern unsigned long sun4v_ncs_request(u
 #define HV_GRP_CORE			0x0001
 #define HV_GRP_INTR			0x0002
 #define HV_GRP_SOFT_STATE		0x0003
+#define HV_GRP_TM			0x0080
 #define HV_GRP_PCI			0x0100
 #define HV_GRP_LDOM			0x0101
 #define HV_GRP_SVC_CHAN			0x0102
 #define HV_GRP_NCS			0x0103
 #define HV_GRP_RNG			0x0104
+#define HV_GRP_PBOOT			0x0105
+#define HV_GRP_TPM			0x0107
+#define HV_GRP_SDIO			0x0108
+#define HV_GRP_SDIO_ERR			0x0109
+#define HV_GRP_REBOOT_DATA		0x0110
 #define HV_GRP_NIAG_PERF		0x0200
 #define HV_GRP_FIRE_PERF		0x0201
 #define HV_GRP_N2_CPU			0x0202
--- a/arch/sparc/kernel/hvapi.c
+++ b/arch/sparc/kernel/hvapi.c
@@ -28,11 +28,17 @@ static struct api_info api_table[] = {
 	{ .group = HV_GRP_CORE,		.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_INTR,					},
 	{ .group = HV_GRP_SOFT_STATE,				},
+	{ .group = HV_GRP_TM,					},
 	{ .group = HV_GRP_PCI,		.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_LDOM,					},
 	{ .group = HV_GRP_SVC_CHAN,	.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_NCS,		.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_RNG,					},
+	{ .group = HV_GRP_PBOOT,				},
+	{ .group = HV_GRP_TPM,					},
+	{ .group = HV_GRP_SDIO,					},
+	{ .group = HV_GRP_SDIO_ERR,				},
+	{ .group = HV_GRP_REBOOT_DATA,				},
 	{ .group = HV_GRP_NIAG_PERF,	.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_FIRE_PERF,				},
 	{ .group = HV_GRP_N2_CPU,				},


