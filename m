Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2CBAz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:55:26 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473Ab2CBAzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:55:24 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/5] OpenRISC: Use generic bitops.h
Date: Fri,  2 Mar 2012 01:55:12 +0100
Message-Id: <1330649715-32438-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330649715-32438-1-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to reinvent the wheel.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 11162e6..a283165 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -4,6 +4,7 @@ header-y += spr_defs.h
 
 generic-y += atomic.h
 generic-y += auxvec.h
+generic-y += bitops.h
 generic-y += bitsperlong.h
 generic-y += bug.h
 generic-y += bugs.h
-- 
1.7.7.3

