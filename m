Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072Ab2ERK0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161032Ab2ERK0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:26:36 -0400
Date: Fri, 18 May 2012 12:26:26 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/3] x86: x2apic/cluster: Fix whitespace, trivial
Message-ID: <20120518102617.GA31517@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 48f3103..8f012b2 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -81,7 +81,7 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 }
 
 static void
- x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
-- 
1.7.6.5

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
