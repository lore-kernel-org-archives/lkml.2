Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2ADP2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:28:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2ADP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:28:23 -0500
Date: Wed, 4 Jan 2012 07:27:56 -0800
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-9e183426bfb52bb44bf3c443d6587e4d02478603@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, joerg.roedel@amd.com,
        gleb@redhat.com, tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, joerg.roedel@amd.com, a.p.zijlstra@chello.nl,
        gleb@redhat.com, tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <1317816084-18026-5-git-send-email-gleb@redhat.com>
References: <1317816084-18026-5-git-send-email-gleb@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Fix copy & paste error in description
Git-Commit-ID: 9e183426bfb52bb44bf3c443d6587e4d02478603
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Jan 2012 07:28:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e183426bfb52bb44bf3c443d6587e4d02478603
Gitweb:     http://git.kernel.org/tip/9e183426bfb52bb44bf3c443d6587e4d02478603
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Wed, 5 Oct 2011 14:01:19 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 3 Jan 2012 15:17:14 -0200

perf kvm: Fix copy & paste error in description

The --host option certainly enables host-data collection.

Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: kvm@vger.kernel.org
Link: http://lkml.kernel.org/r/1317816084-18026-5-git-send-email-gleb@redhat.com
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
