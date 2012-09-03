Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2ICD6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:58:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34739 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICD6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:58:05 -0400
Message-ID: <50442AC5.9050902@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 11:57:57 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 0/4] linsched: fix issues to make the test results more
 accurately
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090303-0260-0000-0000-000001C8EAC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch set fix several issues in linsched, help it to
behave more close to the real world, in order to make the
test results more accurately.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/arch/linsched/kernel/irq.c |    4 ++++
 b/tools/linsched/hrtimer.c   |    1 -
 b/tools/linsched/linsched.h  |    2 ++
 b/tools/linsched/numa.c      |    2 ++
 tools/linsched/hrtimer.c     |   32 +++++++++++++++++++++++++++++++-
 5 files changed, 39 insertions(+), 2 deletions(-)

