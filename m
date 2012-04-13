Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab2DMSXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:23:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2DMSXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:23:16 -0400
Date: Fri, 13 Apr 2012 11:23:04 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-61d5bf5b01a0baf0934a4bd3d15bc14e4bbf202c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1333643188-26895-3-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix thread map that is type pid_t
Git-Commit-ID: 61d5bf5b01a0baf0934a4bd3d15bc14e4bbf202c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:23:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61d5bf5b01a0baf0934a4bd3d15bc14e4bbf202c
Gitweb:     http://git.kernel.org/tip/61d5bf5b01a0baf0934a4bd3d15bc14e4bbf202c
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:26:26 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 17:38:50 -0300

perf tools: Fix thread map that is type pid_t

Thread map is actually type pid_t and not int.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1333643188-26895-3-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread_map.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 7da80f1..f718df8 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -6,7 +6,7 @@
 
 struct thread_map {
 	int nr;
-	int map[];
+	pid_t map[];
 };
 
 struct thread_map *thread_map__new_by_pid(pid_t pid);
