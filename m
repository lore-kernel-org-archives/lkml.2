Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab1BEHUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 02:20:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48670 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1BEHUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 02:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:in-reply-to:references;
        b=IARcJ0g/Bz8hBXE6ZCXAco4i28+jVKMqr8yToZUkKkEl+yi5mENXCuyeKKKWXKi2df
         1yfBNk3W87EATtnLmMUatEm27yRpXT3QrrAPUBLZ86YaYTU5sfUd+27yHcrHW+BsxzID
         egHH9p0FZJY5ih8aia1NnBbv5l8hej87OwdwM=
Date: Fri, 04 Feb 2011 23:20:39 -0800 (PST)
From: Michael Witten <mfwitten@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tools/perf: Makefile: Use $(QUIET_GEN) for perf.so
Message-Id: <1296890359-22659-1-git-send-email-mfwitten@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
In-Reply-To: <tip-067187fc9f1d09738fc833392e117f125cb6bbad@git.kernel.org>
References: <tip-067187fc9f1d09738fc833392e117f125cb6bbad@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 3 Feb 2011 22:10:55 -0600
Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d1984ee..0b68575 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -326,7 +326,7 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	@python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
 						--build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
-- 
1.7.4.rc0

