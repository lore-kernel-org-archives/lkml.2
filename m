Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2BZX4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:56:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BZX4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:56:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 27 Feb 2012 08:54:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 00/21] mm: lru_lock splitting
Message-Id: <20120227085438.06f8673e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F487215.7000307@openvz.org>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120225111515.1275e04c.kamezawa.hiroyu@jp.fujitsu.com>
	<4F487215.7000307@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Feb 2012 09:31:01 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Thu, 23 Feb 2012 17:51:36 +0400
> > Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
> >
> >> v3 changes:
> >> * inactive-ratio reworked again, now it always calculated from from scratch
> >> * hierarchical pte reference bits filter in memory-cgroup reclaimer
> >> * fixed two bugs in locking, found by Hugh Dickins
> >> * locking functions slightly simplified
> >> * new patch for isolated pages accounting
> >> * new patch with lru interleaving
> >>
> >> This patchset is based on next-20120210
> >>
> >> git: https://github.com/koct9i/linux/commits/lruvec-v3
> >>
> >
> > I wonder.... I just wonder...if we can split a lruvec in a zone into small
> > pieces of lruvec and have splitted LRU-lock per them, do we need per-memcg-lrulock ?
> 
> What per-memcg-lrulock? I don't have it.
> last patch splits lruvecs in memcg with the same factor.
> 
Okay, I missed it.

Thanks,
-Kame

