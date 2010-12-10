Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0LJNMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:12:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:30071 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab0LJNMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:12:21 -0500
Message-Id: <0d30dc$ke2a04@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208";a="685844491"
Date: Fri, 10 Dec 2010 13:12:16 +0000
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: BUG at perf_ctx_adjust_freq (kernel/perf_event.c:1582)
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1291985923.2538.4.camel@localhost>
References: <c6d829$pqibha@fmsmga001.fm.intel.com> <AANLkTi=ZjBKkxJDDSCNzsZ_oma485xKafMEXWet8EOXd@mail.gmail.com> <1291985923.2538.4.camel@localhost>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 20:58:43 +0800, Lin Ming <ming.m.lin@intel.com> wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> > Strange OOPS, not sure what triggered it, but in case it helps:
> 
> Hi,
> 
> Can you reproduce it?

I was debugging an X crash, just a normal use-after-free, which managed
to take down the box whilst under gdb. I've rerun that scenario several
times and I've not managed to trigger the OOPS again.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
