Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2FTLky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:40:54 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15992 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2FTLkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:40:52 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, <devel@openvz.org>
Subject: [PATCH 0/2] Show per-cpu data in cpuacct stats
Date: Wed, 20 Jun 2012 15:38:14 +0400
Message-Id: <1340192296-15939-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Peter, Paul, and others:

Since Peter is currently reworking put_prev_task/pick_next_task, I split
my cpu stats series in two: the part that touches cpuacct is not dependent
on that at all. So please let me know if you are comfortable with merging this.

Is basically the same code as my last submission, which gets rid of the
key:value mapping to expose the information, resorting to the seq_string
interface.

Glauber Costa (2):
  account guest time per-cgroup as well.
  expose fine-grained per-cpu data for cpuacct stats

 kernel/sched/core.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

-- 
1.7.10.2

