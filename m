Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2LTLOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:14:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab2LTLOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:14:09 -0500
Date: Thu, 20 Dec 2012 11:14:05 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] sched: numa: ksm: fix oops in task_numa_placment()
Message-ID: <20121220111405.GE10819@suse.de>
References: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 05:42:16PM -0800, Hugh Dickins wrote:
> task_numa_placement() oopsed on NULL p->mm when task_numa_fault()
> got called in the handling of break_ksm() for ksmd.  That might be a
> peculiar case, which perhaps KSM could takes steps to avoid? but it's
> more robust if task_numa_placement() allows for such a possibility.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
