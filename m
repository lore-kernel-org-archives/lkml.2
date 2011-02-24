Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1BXOL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:11:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:43431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab1BXOLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:11:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,218,1297065600"; 
   d="scan'208";a="712757065"
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110224140214.GI5818@one.firstfloor.org>
References: <1298555968.2220.15.camel@localhost>
	 <20110224140214.GI5818@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 22:11:24 +0800
Message-Id: <1298556684.2220.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 22:02 +0800, Andi Kleen wrote:
> > +	[ C(OP_READ) ] = {
> > +		[ C(RESULT_ACCESS) ] = 0x04d1, /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
> > +		[ C(RESULT_MISS)   ] = 0x0,
> > +	},
> > +	[ C(OP_WRITE) ] = {
> > +		[ C(RESULT_ACCESS) ] = 0x0424, /* L2_RQSTS.RFO_HITS */
> > +		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS */
> 
> No! You really need offcore here. L2 is not LLC!!!
> See the offcore patchkit which fixes this for Nehalem.

Yes, I know that.
But I write it like this for now since the offcore patchkit has not been
merged yet.

> 
> -Andi


