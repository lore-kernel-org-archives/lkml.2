Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1CXPRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:17:19 -0400
Received: from kroah.org ([198.145.64.141]:51218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab1CXPRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:17:14 -0400
Date: Thu, 24 Mar 2011 08:17:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 2.6.32.35
Message-ID: <20110324151707.GB635@kroah.com>
References: <20110324151649.GA635@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324151649.GA635@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ca59a37..63fce32 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .34
+EXTRAVERSION = .35
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f9af60f..183d437 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4167,8 +4167,6 @@ static void tp_perf_event_destroy(struct perf_event *event)
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
-	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
 	/*
 	 * Raw tracepoint data is a severe data leak, only allow root to
 	 * have these.
