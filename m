Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0LOX6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:58:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755893Ab0LOX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:05 -0500
Date: Wed, 15 Dec 2010 15:55:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Transparent Hugepage Support #33
Message-Id: <20101215155545.303ca2c2.akpm@linux-foundation.org>
In-Reply-To: <20101215051540.GP5638@random.random>
References: <20101215051540.GP5638@random.random>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 06:15:40 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Some of some relevant user of the project:
> 
> KVM Virtualization
> GCC (kernel build included, requires a few liner patch to enable)
> JVM
> VMware Workstation
> HPC
> 
> It would be great if it could go in -mm.

That all merged pretty easily on top of the current mm pile.  Except
for kvm-mmu-transparent-hugepage-support.patch which needs some thought
and testing to get it merged into the KVM changes in linux-next.  I
simply omitted kvm-mmu-transparent-hugepage-support.patch so please
take a look?


