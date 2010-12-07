Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0LGDcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:32:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0LGDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:32:52 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=18k_c8EquKYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=gu6fZOg2AAAA:8 a=GDm3f2tATRieFBFOxdgA:9 a=8r0JSzexVVohO76CHq-v8k0t6SAA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 01/10] sched: Change rt_task(prev) in
 pre_schedule_rt to likely
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <AANLkTimO+aBQD530btPmH3o7j931KEmFP=GKia-039wO@mail.gmail.com>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021328.207196531@goodmis.org>
	 <AANLkTimO+aBQD530btPmH3o7j931KEmFP=GKia-039wO@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Dec 2010 22:32:49 -0500
Message-ID: <1291692769.16223.137.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 11:25 +0800, Yong Zhang wrote:
> On Tue, Dec 7, 2010 at 9:58 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > As found with the branch annotation profiler, the unlikely(rt_task(prev))
> > in pre_schedule_rt() is always wrong. In fact it should be likely due to
> > the fact that we got to this function because we used prev's scheduling
> > class (which had to be rt).
> >
> > Change the unlikely(rt_task(prev)) to likely(rt_task(prev))
> 
> I have sent a more radical patch before but it get ignored.
> http://marc.info/?l=linux-kernel&m=126572702600950&w=2

I like yours better. I'll add that one to my queue instead.

Thanks,

-- Steve



