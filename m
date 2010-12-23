Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0LWBKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:10:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:22262 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0LWBKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:10:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,216,1291622400"; 
   d="scan'208";a="365582830"
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20101222101443.GA1640@elte.hu>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293006808.2170.42.camel@laptop> <1293008656.2170.67.camel@laptop>
	 <20101222101443.GA1640@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 09:14:37 +0800
Message-ID: <1293066877.2565.164.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 18:14 +0800, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-12-22 at 09:33 +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-12-22 at 16:12 +0800, Lin Ming wrote:
> > > > It's applied on top of tip/master(3ea1f4f89) and Andi's offcore
> > > > patchsets are needed. 
> > > 
> > > I still haven't gotten a version of that I'm willing to apply.
> > 
> > That is, maybe you could pick up his patches and finish them, Andi
> > doesn't seem interested in getting them sorted.
> 
> FYI, this one of Peter's reviews that went unaddressed:
> 
>   https://lkml.org/lkml/2010/12/1/213
> 
> and he got no reply to that feedback in the past 3 weeks. (There may be other issues 
> outstanding, i have not checked.)

Andi mentioned he will be on vacation in December, see the end of below
mail.
http://marc.info/?l=linux-kernel&m=129136895415202&w=2

> 
> Thanks,
> 
> 	Ingo


