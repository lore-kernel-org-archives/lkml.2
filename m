Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1FQNi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:38:26 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:57948
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756683Ab1FQNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:37:10 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMXSHO-02-52J-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] perf, tools: Fix copy&paste error in perf-kvm option description
Date: Fri, 17 Jun 2011 15:37:33 +0200
Message-ID: <1308317854-27398-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --host option certainly enables host-data collection.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/builtin-kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 34d1e85..032324a 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -38,7 +38,7 @@ static const struct option kvm_options[] = {
 	OPT_BOOLEAN(0, "guest", &perf_guest,
 		    "Collect guest os data"),
 	OPT_BOOLEAN(0, "host", &perf_host,
-		    "Collect guest os data"),
+		    "Collect host os data"),
 	OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
 		   "guest mount directory under which every guest os"
 		   " instance has a subdir"),
-- 
1.7.4.1


