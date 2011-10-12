Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1JLMDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:03:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1JLMDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:03:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=GzwhVAU7U6Ch0Ip8p1rjbgB7WyW5VeOdTCa92UwS8sMx6GHJvs6l6SR3QwQpY9pm2
	zorcIdQkmjKR5aFu/2AvA==
Date: Wed, 12 Oct 2011 14:03:28 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf: fix compilation when NO_NEWT_SUPPORT is set
Message-ID: <20111012120328.GA1619@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch, relative to tip/master, makes perf compile
when NO_NEWT_SUPPORT is set.  It also fixes the line
formatting to fit 80 columns.

Please test with NO_NEWT.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 395b2e7..74f846d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -109,16 +109,20 @@ struct perf_evlist;
 #ifdef NO_NEWT_SUPPORT
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
-				  const char *help __used, void(*timer)(void *arg) __used, void *arg,
+				  const char *help __used,
+				  void(*timer)(void *arg) __used,
+				  void *arg __used,
 				  int refresh __used)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
-					   int evidx __used, int nr_events __used,
+					   int evidx __used,
+					   int nr_events __used,
 					   void(*timer)(void *arg) __used,
-					   void *arg __used, int delay_secs __used);
+					   void *arg __used,
+					   int delay_secs __used)
 {
 	return 0;
 }
