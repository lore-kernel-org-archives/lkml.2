Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0D1K7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 06:59:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0D1K7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 06:59:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding:x-system-of-record;
	b=yZp/76vS/ZpFJRp1DXda+S4N7gv8Av3Y9rscU9obBz/qWsKAjC+GMn9ips8rZkAqQ
	vFyD1RLtrx+pxbJ7pRSHQ==
Subject: [PATCH v2 0/6] Series short description
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Date: Wed, 28 Apr 2010 03:59:10 -0700
Message-ID: <20100428105907.5495.32844.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements...

---

Nikhil Rao (1):
      sched: add exports tracking cfs bandwidth control statistics

Paul Turner (5):
      sched: introduce primitives to account for CFS bandwidth tracking
      sched: accumulate per-cfs_rq cpu usage
      sched: throttle cfs_rq entities which exceed their local quota
      sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
      sched: hierarchical task accounting for FAIR_GROUP_SCHED


 include/linux/sched.h |    4 +
 init/Kconfig          |    9 +
 kernel/sched.c        |  347 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_fair.c   |  240 +++++++++++++++++++++++++++++++++-
 kernel/sched_rt.c     |   24 +--
 kernel/sysctl.c       |   10 +
 6 files changed, 585 insertions(+), 49 deletions(-)

-- 
Signature
