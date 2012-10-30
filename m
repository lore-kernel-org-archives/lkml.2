Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab2J3P2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:28:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2J3P2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:28:24 -0400
Date: Tue, 30 Oct 2012 08:28:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/31] numa/core patches
Message-Id: <20121030082810.b9576441.akpm@linux-foundation.org>
In-Reply-To: <20121030122032.GC3888@suse.de>
References: <20121025121617.617683848@chello.nl>
	<20121030122032.GC3888@suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Oct 2012 12:20:32 +0000 Mel Gorman <mgorman@suse.de> wrote:

> ...

Useful testing - thanks.  Did I miss the description of what
autonumabench actually does?  How representitive is it of real-world
things?

> I also expect autonuma is continually scanning where as schednuma is
> reacting to some other external event or at least less frequently scanning.

Might this imply that autonuma is consuming more CPU in kernel threads,
the cost of which didn't get included in these results?
