Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1FCWAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:00:08 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:49900 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1FCWAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:00:07 -0400
Date: Fri, 3 Jun 2011 17:59:51 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.co
Subject: [patch] perf: Fix comments in include/linux/perf_event.h
Message-ID: <alpine.DEB.2.00.1106031757090.29381@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix include/linux/perf_event.h comments to be consistent with the actual
#define names.  This is trivial, but it can be a bit confusing when first 
reading through the file.

Vince
vweaver1@eecs.utk.edu

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..e0786e3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -137,14 +137,14 @@ enum perf_event_sample_format {
  *
  * struct read_format {
  *	{ u64		value;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		id;           } && PERF_FORMAT_ID
  *	} && !PERF_FORMAT_GROUP
  *
  *	{ u64		nr;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		value;
  *	    { u64	id;           } && PERF_FORMAT_ID
  *	  }		cntr[nr];
