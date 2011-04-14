Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1DNGob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:44:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38305 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1DNGoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:44:30 -0400
Date: Thu, 14 Apr 2011 08:44:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86-64, NUMA: fix fakenuma boot failure
Message-ID: <20110414064414.GA15535@elte.hu>
References: <20110412153212.B514.A69D9226@jp.fujitsu.com>
 <20110412071318.GA10425@mtj.dyndns.org>
 <20110413160239.D72A.A69D9226@jp.fujitsu.com>
 <20110413193219.GF3987@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413193219.GF3987@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Apr 13, 2011 at 04:02:43PM +0900, KOSAKI Motohiro wrote:
> > Your patch have two mistake.
> > 
> >  1) link_thread_siblings() is for HT
> >     set_cpu_sibling_map() has another sibling calculations.
> >  2) numa_set_node() is not enough. scheduler is using node_to_cpumask_map[] too.
> 
> Thanks for seeing this through but your patch is badly whitespace broken.  
> Can you please check your mail setup and repost? [...]

Hm, the patch is whitespace clean and applies without fuzz here. Are you sure 
you processed it the right way?

Thanks,

	Ingo
