Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab2EDTV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:21:29 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39506 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab2EDTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:21:26 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 7/7] cpusets: Remove out-dated comment about
 cpuset_track_online_cpus
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:50:43 +0530
Message-ID: <20120504192037.4603.64381.stgit@srivatsabhat>
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050409-0260-0000-0000-000000FD9D8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset_track_online_cpus() is no longer present. So remove the
outdated comment and replace it with reference to cpuset_update_active_cpus()
which is its equivalent.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6446095..2fdbe10 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2257,7 +2257,7 @@ void cpuset_update_active_cpus(bool cpu_online)
 /*
  * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
  * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
- * See also the previous routine cpuset_track_online_cpus().
+ * See cpuset_update_active_cpus() for CPU hotplug handling.
  */
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)

