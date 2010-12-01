Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0LAB7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:59:24 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50599 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab0LAB6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uYjToMvDjPEGNAjQ3sN47iYXWFRoL1sYM8HNbXhZcFFS+RiN+Szw6McHrfkjF/YNlS
         9AHOeIPveFSfsXWwwPFYo+rsdn7b6B+tSLPQZi/PgxPjzP8OfFA/W8nJvtUcJUC2mnrD
         RNkNQXHFjv/bp/20xw5LXJflSnyY0aYMvd+EE=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 12/14] perf: Fix spelling mistake in test documentation
Date: Tue, 30 Nov 2010 19:57:20 -0600
Message-Id: <1291168642-11402-13-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-test.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
index 1c4b5f5..2c3b462 100644
--- a/tools/perf/Documentation/perf-test.txt
+++ b/tools/perf/Documentation/perf-test.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command does assorted sanity tests, initially thru linked routines but
+This command does assorted sanity tests, initially through linked routines but
 also will look for a directory with more tests in the form of scripts.
 
 OPTIONS
-- 
1.7.3.2

