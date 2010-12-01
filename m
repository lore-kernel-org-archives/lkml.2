Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0LAB6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36381 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0LAB6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ib9svFcT13uztXwB1ciAaAv1Df/BuKPpBKSvkQh8IYZm5WxE3KxxMTftShHO5zvpQr
         BnLC0lLl0xs1prFUvpYphwD2Elk5g+8XIfJjkdr/0DSLYqv68no97wcFPPH19tibHYFv
         MgsPVQAcsUmF7LGMMtfDnFqrmymQVtJBhZ+YA=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 07/14] perf: Fix spelling mistake in probe documentation
Date: Tue, 30 Nov 2010 19:57:15 -0600
Message-Id: <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
 
-- 
1.7.3.2

