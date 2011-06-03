Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab1FCEo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 00:44:56 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:50020 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1FCEo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 00:44:56 -0400
Date: Fri, 3 Jun 2011 00:44:24 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrea Righi <andrea@betterlinux.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Izik Eidus <ieidus@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1434914877.378198.1307076264791.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110602143143.GI23047@sequoia.sous-sol.org>
Subject: Re: [BUG 3.0.0-rc1] ksm: NULL pointer dereference in ksm_do_scan()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> * CAI Qian (caiqian@redhat.com) wrote:
> > madvise(0x2210000, 4096, 0xc /* MADV_??? */) = 0
> > --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> 
> Right, that's just what the program is trying to do, segfault.
> 
> > +++ killed by SIGSEGV (core dumped) +++
> > Segmentation fault (core dumped)
> >
> > Did I miss anything?
> 
> I found it works but not 100% of the time.
> 
> So I just run the bug in a loop.
Still no luck here.
# while :; do ./test ; done
Segmentation fault (core dumped)
Segmentation fault (core dumped)
Segmentation fault (core dumped)
Segmentation fault (core dumped)
...

I can't really see what different with the hardware
here. It is only a NUMA server system.
