Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1ICWmC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 18:42:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51218 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1ICWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 18:41:59 -0400
Date: Sun, 4 Sep 2011 00:41:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        lenb@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch 1/2] Rename the "llist" (lockless list) to "llstack" (lockless stack)
Message-ID: <20110903224155.GG7761@one.firstfloor.org>
References: <20110903174721.390074195@efficios.com> <20110903175543.363519825@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903175543.363519825@efficios.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't see why a rename is necessary. People implement stacks and queues
and all other kinds of data structures using the standard list.h.
No reason why this shouldn't work with llist.h either.

I would assume everyone hacking on the Linux kernel will understand
that a list can be used as a building block for all of these.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
