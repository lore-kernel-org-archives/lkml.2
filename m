Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab0HCSWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:22:51 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19489 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab0HCSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:22:48 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 5/5] documentation: Mention that KProbes is supported on MIPS
Date: Tue,  3 Aug 2010 11:22:22 -0700
Message-Id: <1280859742-26364-6-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 03 Aug 2010 18:22:48.0266 (UTC) FILETIME=[E030A2A0:01CB3338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS now has KProbes support, so kprobes.txt should reflect it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 Documentation/kprobes.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 6653017..1762b81 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -285,6 +285,7 @@ architectures:
 - sparc64 (Return probes not yet implemented.)
 - arm
 - ppc
+- mips
 
 3. Configuring Kprobes
 
-- 
1.7.1.1

