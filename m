Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0EZPaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:30:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab0EZP3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:29:40 -0400
Date: Wed, 26 May 2010 11:24:03 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -v2 0/5] always lock the root anon_vma
Message-ID: <20100526112403.635be0ed@annuminas.surriel.com>
In-Reply-To: <4BFC9CCF.6000809@redhat.com>
References: <20100512133815.0d048a86@annuminas.surriel.com>
	<20100512134029.36c286c4@annuminas.surriel.com>
	<20100512210216.GP24989@csn.ul.ie>
	<4BEB18BB.5010803@redhat.com>
	<20100513095439.GA27949@csn.ul.ie>
	<20100513103356.25665186@annuminas.surriel.com>
	<20100513140919.0a037845.akpm@linux-foundation.org>
	<4BFC9CCF.6000809@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 00:00:15 -0400
Rik van Riel <riel@redhat.com> wrote:
> On 05/13/2010 05:09 PM, Andrew Morton wrote:
> 
> > I'm not very confident in merging all these onto the current MM pile.
> 
> Blah.  I thought I just did that (and wondered why it was
> so easy), and then I saw that the MMOTM git tree is old
> and does not have the COMPACTION code :(
> 
> On to doing this thing again :/

Andrew, here are the patches to always lock the root anon_vma,
ported to the latest -mm tree.

These patches implement Linus's idea of always locking the root
anon_vma and contain all the fixes and improvements suggested 
by Andrea.

This should fix the last bits of the anon_vma locking.

-- 
All rights reversed.
