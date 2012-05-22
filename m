Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2EVL7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:59:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2EVL7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:59:15 -0400
Date: Tue, 22 May 2012 12:59:10 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120522115910.GA3353@suse.de>
References: <20120517213120.GA12329@redhat.com>
 <20120518185851.GA5728@redhat.com>
 <20120521154709.GA8697@redhat.com>
 <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
 <20120521200118.GA12123@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120521200118.GA12123@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:01:18PM -0400, Dave Jones wrote:
> On Mon, May 21, 2012 at 12:39:19PM -0700, Linus Torvalds wrote:
> 
>  > But there's not a lot of recent stuff. The thing that jumps out is Mel
>  > Gorman's recent commit cc9a6c8776615 ("cpuset: mm: reduce large
>  > amounts of memory barrier related damage v3"), which has a whole new
>  > loop with that scary mpol_cond_put() usage. And there's we had
>  > problems with vma merging..
>  > 
>  > Dave, how recent is this problem? Have you already tried older kernels?
> 
> I tried bisecting, but couldn't find a 'good' kernel.
> I Went back as far as 3.0, before that I kept running into compile failures.
> Newer gcc/binutils really seems to dislike 2.6.x now.
> 

This bug is really old as it triggers as far back as 2.6.32.58. I don't
know why yet.

-- 
Mel Gorman
SUSE Labs
