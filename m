Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2JUMby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:31:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49357 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2JUMbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:31:53 -0400
Date: Sun, 21 Oct 2012 14:31:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question on NUMA page migration
Message-ID: <20121021123147.GB19229@gmail.com>
References: <5081777A.8050104@redhat.com>
 <50836060.4050408@gmail.com>
 <5083608E.6040209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5083608E.6040209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 10/20/2012 10:39 PM, Ni zhan Chen wrote:
> >On 10/19/2012 11:53 PM, Rik van Riel wrote:
> >>Hi Andrea, Peter,
> >>
> >>I have a question on page refcounting in your NUMA
> >>page migration code.
> >>
> >>In Peter's case, I wonder why you introduce a new
> >>MIGRATE_FAULT migration mode. If the normal page
> >>migration / compaction logic can do without taking
> >>an extra reference count, why does your code need it?
> >
> >Hi Rik van Riel,
> >
> >This is which part of codes? Why I can't find MIGRATE_FAULT in latest
> >v3.7-rc2?
> 
> It is in tip.git in the numa/core branch.

The Git access URI is:

  git pull  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/core
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/core

Thanks,

	Ingo

