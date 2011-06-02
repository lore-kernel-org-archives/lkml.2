Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1FBOfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:35:21 -0400
Received: from sous-sol.org ([216.99.217.87]:50573 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750948Ab1FBOfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:35:19 -0400
Date: Thu, 2 Jun 2011 07:31:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: CAI Qian <caiqian@redhat.com>
Cc: Andrea Righi <andrea@betterlinux.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>, Mel Gorman <mel@csn.ul.ie>,
        Izik Eidus <ieidus@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 3.0.0-rc1] ksm: NULL pointer dereference in ksm_do_scan()
Message-ID: <20110602143143.GI23047@sequoia.sous-sol.org>
References: <20110601222032.GA2858@thinkpad>
 <2144269697.363041.1306998593180.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2144269697.363041.1306998593180.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* CAI Qian (caiqian@redhat.com) wrote:
> madvise(0x2210000, 4096, 0xc /* MADV_??? */) = 0
> --- SIGSEGV (Segmentation fault) @ 0 (0) ---

Right, that's just what the program is trying to do, segfault.

> +++ killed by SIGSEGV (core dumped) +++
> Segmentation fault (core dumped)
> 
> Did I miss anything?

I found it works but not 100% of the time.

So I just run the bug in a loop.
