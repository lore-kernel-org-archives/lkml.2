Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1HNQJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1HNQJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.717701869@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [64/90] sparc: Add T3 sun4v cpu type and hypervisor group defines.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 15e3608d7c273947dbf2eadbcaa66e51143928fb ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/hypervisor.h |    1 +
 arch/sparc/include/asm/spitfire.h   |    1 +
 arch/sparc/kernel/hvapi.c           |    1 +
 3 files changed, 3 insertions(+)

--- a/arch/sparc/include/asm/hypervisor.h
+++ b/arch/sparc/include/asm/hypervisor.h
@@ -2950,6 +2950,7 @@ extern unsigned long sun4v_ncs_request(u
 #define HV_GRP_N2_CPU			0x0202
 #define HV_GRP_NIU			0x0204
 #define HV_GRP_VF_CPU			0x0205
+#define HV_GRP_KT_CPU			0x0209
 #define HV_GRP_DIAG			0x0300
 
 #ifndef __ASSEMBLY__
--- a/arch/sparc/include/asm/spitfire.h
+++ b/arch/sparc/include/asm/spitfire.h
@@ -42,6 +42,7 @@
 #define SUN4V_CHIP_INVALID	0x00
 #define SUN4V_CHIP_NIAGARA1	0x01
 #define SUN4V_CHIP_NIAGARA2	0x02
+#define SUN4V_CHIP_NIAGARA3	0x03
 #define SUN4V_CHIP_UNKNOWN	0xff
 
 #ifndef __ASSEMBLY__
--- a/arch/sparc/kernel/hvapi.c
+++ b/arch/sparc/kernel/hvapi.c
@@ -38,6 +38,7 @@ static struct api_info api_table[] = {
 	{ .group = HV_GRP_N2_CPU,				},
 	{ .group = HV_GRP_NIU,					},
 	{ .group = HV_GRP_VF_CPU,				},
+	{ .group = HV_GRP_KT_CPU,				},
 	{ .group = HV_GRP_DIAG,		.flags = FLAG_PRE_API	},
 };
 


