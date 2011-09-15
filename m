Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1IOByd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 21:54:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:39098 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab1IOByc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 21:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48569231"
Subject: Re: [PATCH] slub Discard slab page only when node partials >
 minimum setting
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <christoph@lameter.com>
Cc: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <CALmdxiMrDNDvhAmi88-0-1KBdyTwExZPy3Fh9_5TxB+XhK7vjw@mail.gmail.com>
References: <1315188460.31737.5.camel@debian>
	 <alpine.DEB.2.00.1109061914440.18646@router.home>
	 <1315357399.31737.49.camel@debian>
	 <alpine.DEB.2.00.1109062022100.20474@router.home>
	 <4E671E5C.7010405@cs.helsinki.fi>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>
	 <alpine.DEB.2.00.1109071003240.9406@router.home>
	 <1315442639.31737.224.camel@debian>
	 <alpine.DEB.2.00.1109081336320.14787@router.home>
	 <1315557944.31737.782.camel@debian>	<1315902583.31737.848.camel@debian>
	 <CALmdxiMuF6Q0W4ZdvhK5c4fQs8wUjcVGWYGWBjJi7WOfLYX=Gw@mail.gmail.com>
	 <1316050363.8425.483.camel@debian>
	 <CALmdxiMrDNDvhAmi88-0-1KBdyTwExZPy3Fh9_5TxB+XhK7vjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 10:00:31 +0800
Message-ID: <1316052031.8425.491.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 09:51 +0800, Christoph Lameter wrote:
> I have not had time to get into this. I was hoping you could come up
> with something. 

Thanks! 
Um, let me have some try.

> 
> On Wed, Sep 14, 2011 at 8:32 PM, Alex,Shi <alex.shi@intel.com> wrote:
>         On Tue, 2011-09-13 at 23:04 +0800, Christoph Lameter wrote:
>         > Sorry to be that late with a response but my email setup is
>         screwed
>         > up.
>         >
>         > I was more thinking about the number of slab pages in the
>         partial
>         > caches rather than the size of the objects itself being an
>         issue. I
>         > believe that was /sys/kernel/slab/*/cpu_partial.
>         >
>         > That setting could be tuned further before merging. An
>         increase there
>         > causes additional memory to be caught in the partial list.
>         But it
>         > reduces the node lock pressure further.
>         >
>         
>         
>         Yeah, I think so. The more cpu partial page, the quicker to
>         getting
>         slabs. Maybe it's better to considerate the system memory size
>         to set
>         them. Do you has some plan or suggestions on tunning?
>         
>         
>         
>         
> 


