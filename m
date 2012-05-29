Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2E2TeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab2E2TeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:34:08 -0400
Date: Tue, 29 May 2012 21:27:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Basically the same changes we discussed before.

Changes:

	- do not introduce is_swbp_at_addr_fast(), change
	  is_swbp_at_addr() to check current->mm == mm as
	  Peter suggested

	- 2/7 is new

Oleg.

