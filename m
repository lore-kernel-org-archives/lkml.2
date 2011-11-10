Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1KJAdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:33:07 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2326 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab1KJAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:33:06 -0500
From: David Daney <david.daney@cavium.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] MIPS: Randomize PIE load address
Date: Wed,  9 Nov 2011 16:32:58 -0800
Message-Id: <1320885178-24201-2-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1320885178-24201-1-git-send-email-david.daney@cavium.com>
References: <1320885178-24201-1-git-send-email-david.daney@cavium.com>
X-OriginalArrivalTime: 10 Nov 2011 00:33:06.0059 (UTC) FILETIME=[50490DB0:01CC9F40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... by selecting ARCH_BINFMT_ELF_RANDOMIZE_PIE

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8f1b76a..64934ad 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -25,6 +25,7 @@ config MIPS
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_JUMP_LABEL
 	select IRQ_FORCED_THREADING
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 
 menu "Machine selection"
 
-- 
1.7.2.3

