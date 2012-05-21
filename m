Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab2EUUCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759211Ab2EUUCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:02:13 -0400
Date: Mon, 21 May 2012 16:01:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120521200118.GA12123@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
	Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20120517213120.GA12329@redhat.com>
 <20120518185851.GA5728@redhat.com>
 <20120521154709.GA8697@redhat.com>
 <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 12:39:19PM -0700, Linus Torvalds wrote:

 > But there's not a lot of recent stuff. The thing that jumps out is Mel
 > Gorman's recent commit cc9a6c8776615 ("cpuset: mm: reduce large
 > amounts of memory barrier related damage v3"), which has a whole new
 > loop with that scary mpol_cond_put() usage. And there's we had
 > problems with vma merging..
 > 
 > Dave, how recent is this problem? Have you already tried older kernels?

I tried bisecting, but couldn't find a 'good' kernel.
I Went back as far as 3.0, before that I kept running into compile failures.
Newer gcc/binutils really seems to dislike 2.6.x now.

	Dave
