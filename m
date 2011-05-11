Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1EKPox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:44:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57857 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1EKPos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] perf: Split it some more
Date: Wed, 11 May 2011 15:16:54 +0200
Message-Id: <1305119816-26280-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi guys,

here's some more perf_event.c splitting, more specifically cgroup and
callchain-related stuff. Builds fine here. I'll add the persistent.c
stuff later after cooking it a bit longer and incorporating the latest
review comments.

The two patches are also available in a pullable form:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-split

Thanks.
