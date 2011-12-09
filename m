Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1LIVMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 16:12:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55178 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab1LIVMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 16:12:35 -0500
Date: Fri, 9 Dec 2011 13:11:57 -0800
From: Kees Cook <kees@outflux.net>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: standardize /proc/iomem "Kernel code" name
Message-ID: <20111209211157.GA2146@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other ports use "Kernel code" to identify the Kernel text segment
in /proc/iomem. Change the ARM resources to do the same.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3448a3f..a34dbf6 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -158,7 +158,7 @@ static struct resource mem_res[] = {
 		.flags = IORESOURCE_MEM
 	},
 	{
-		.name = "Kernel text",
+		.name = "Kernel code",
 		.start = 0,
 		.end = 0,
 		.flags = IORESOURCE_MEM
-- 
1.7.5.4


-- 
Kees Cook                                            @outflux.net
