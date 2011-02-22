Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1BVRsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:48:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58148 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1BVRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QprTJTFH9/yKQVRDVqi968yidX/ajk+IWghEkfV80frTDL8feG9djBrxxotyPFmYr5
         5Zk6tUpgKRulHcqqsELTqPU7oedmQRNsEHSZ+QWjY2zOgpnP0EFTTrVlk9pUuM8VrAKK
         X9FfokKyCzALEqS60ygQSVAJ6C6uNxOoq5Tis=
Date: Tue, 22 Feb 2011 18:45:57 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf lock: show valid sort keys in usage
Message-ID: <20110222174557.GB9687@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 tools/perf/builtin-lock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2b36def..0305a40 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -893,7 +893,7 @@ static const char * const report_usage[] = {
 
 static const struct option report_options[] = {
 	OPT_STRING('k', "key", &sort_key, "acquired",
-		    "key for sorting"),
+		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
 	/* TODO: type */
 	OPT_END()
 };
-- 
1.7.4.rc3

