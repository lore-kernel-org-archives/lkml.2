Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2FGWFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:05:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2FGWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:05:51 -0400
Date: Thu, 7 Jun 2012 15:05:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: boot problem with next-20120607
Message-Id: <20120607150549.63f3ab81.akpm@linux-foundation.org>
In-Reply-To: <20120607135320.7a1298385346bc238a0f92b0@canb.auug.org.au>
References: <20120607135320.7a1298385346bc238a0f92b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012 13:53:20 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> My boot of next-20120607 in PowerPC produces lots of these warnings:
> 
> BUG: Bad rss-counter state mm:c000000278508000 idx:0 val:-27
> BUG: Bad rss-counter state mm:c000000278284000 idx:0 val:-27
> BUG: Bad rss-counter state mm:c000000279e13000 idx:0 val:-27
> BUG: Bad rss-counter state mm:c000000278285400 idx:0 val:-27
> 
> And so on (with different mm, idx and val numbers).  Searching showed me
> commit "mm: correctly synchronize rss-counters at exit/exec" which seems
> to be there to fix this exact problem?

Well that's a worry.  Are you really sure
mm-correctly-synchronize-rss-counters-at-exit-exec.patch was applied at
the time?

There's been an extended amount of inconclusive waffling on that patch,
but I thought it concerned the best way to fix it, rather than
*whether* it fixes it.
