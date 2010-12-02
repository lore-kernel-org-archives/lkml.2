Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0LBLp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:45:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:53677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0LBLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:45:26 -0500
Date: Thu, 2 Dec 2010 11:44:56 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix spelling mistake in documentation
Message-ID: <tip-9d5b7f5b2b2c1ceade1fbbaefb2bd9167436329d@git.kernel.org>
Git-Commit-ID: 9d5b7f5b2b2c1ceade1fbbaefb2bd9167436329d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:44:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d5b7f5b2b2c1ceade1fbbaefb2bd9167436329d
Gitweb:     http://git.kernel.org/tip/9d5b7f5b2b2c1ceade1fbbaefb2bd9167436329d
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:15 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:46 -0200

perf probe: Fix spelling mistake in documentation

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 62de1b7..4e23232 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -115,7 +115,7 @@ Each probe argument follows below syntax.
 
 LINE SYNTAX
 -----------
-Line range is descripted by following syntax.
+Line range is described by following syntax.
 
  "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]"
 
