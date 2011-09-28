Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab1I1Wqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912Ab1I1Wqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:43 2011
Message-Id: <20110928220143.670081718@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Youquan Song <youquan.song@intel.com>, Anhua Xu <anhua.xu@intel.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [174/244] perf, x86: Add model 45 SandyBridge support
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Youquan Song <youquan.song@intel.com>

commit a34668f6beb4ab01e07683276d6a24bab6c175e0 upstream.

Add support to Romely-EP SandyBridge.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Anhua Xu <anhua.xu@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312264895-2010-1-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1495,6 +1495,7 @@ static __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
+	case 45: /* SandyBridge, "Romely-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 


