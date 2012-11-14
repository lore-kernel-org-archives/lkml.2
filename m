Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2KNE2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 23:28:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2KNE2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 23:28:51 -0500
Date: Tue, 13 Nov 2012 20:28:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 21/31] sched, numa, mm: Implement THP migration
Message-Id: <20121113202846.5b1c0e3c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1211131759390.29612@eggly.anvils>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
	<1352826834-11774-22-git-send-email-mingo@kernel.org>
	<20121113184835.GH10092@cmpxchg.org>
	<alpine.LNX.2.00.1211131759390.29612@eggly.anvils>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 18:23:13 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:

> But I vehemently hope that this all very soon vanishes from linux-next,
> and the new stuff is worked on properly for a while, in a separate
> development branch of tip, hopefully converging with Mel's.

Yes please.

The old code in -next has been causing MM integration problems for
months, and -next shuts down from Nov 15 to Nov 26, reopening around
3.7-rc7.  rc7 is too late for this material - let's shoot for
integration in -next at 3.8-rc1.

