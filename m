Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0CQSxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:53:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44987 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0CQSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:53:36 -0400
Date: Thu, 18 Mar 2010 00:23:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v7)
Message-ID: <20100317185327.GV18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
 <20100315171209.GI21127@redhat.com>
 <20100315171921.GJ21127@redhat.com>
 <20100317115427.GR18054@balbir.in.ibm.com>
 <20100317133407.GA9198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100317133407.GA9198@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2010-03-17 09:34:07]:

> > > 
> > > root cgroup
> > > ==========
> > > #time dd if=/dev/zero of=/root/zerofile bs=4K count=1M
> > > 4294967296 bytes (4.3 GB) copied, 56.098 s, 76.6 MB/s
> > > 
> > > real	0m56.614s
> > > 
> > > test1 cgroup with memory limit 100M
> > > ===================================
> > > # time dd if=/dev/zero of=/root/zerofile1 bs=4K count=1M
> > > 4294967296 bytes (4.3 GB) copied, 19.8097 s, 217 MB/s
> > > 
> > > real	0m19.992s
> > > 
> > 
> > This is strange, did you flish the cache between the two runs?
> > NOTE: Since the files are same, we reuse page cache from the
> > other cgroup.
> 
> Files are different. Note suffix "1".
>

Thanks, I'll get the perf output and see what I get. 

-- 
	Three Cheers,
	Balbir
