Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab1DITXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab1DITWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:43 -0400
Message-Id: <20110409191739.813727025@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:39 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: [RFC][PATCH 0/9] perf: Rework event scheduling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a broken out and tested version of a patch I proposed in
an earlier thread with Jiri and Oleg:

  https://lkml.org/lkml/2011/3/31/232

I've not yet gone over the final patch enough to convince myself we can indeed
re-enable the jump_label optimization of the sched_out hook, but at least the
patches are reasonably readable and result in a working kernel (as opposed to
the earlier posting).

Also still to do is look at the cgroup event scheduling code which currently
also violates our event scheduling rules.

