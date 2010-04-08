Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab0DHVXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:23:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041Ab0DHVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:23:08 -0400
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
 perf_prepare_sample()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
	 <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
	 <1270761083.20295.3158.camel@laptop>
	 <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 23:23:04 +0200
Message-ID: <1270761784.20295.3161.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:14 +0200, Stephane Eranian wrote:
> On Thu, Apr 8, 2010 at 11:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
> >>
> >> Are you suggesting you add some padding the PEBS raw sample you
> >> return as PERF_SAMPLE_RAW? Then you need to define what RAW
> >> actually means? Seems here, it would mean more than what the
> >> HW returns.
> >
> > Well, RAW doesn't mean anything much at all, its really a fugly pass
> > some crap around thing.
> >
> > So yeah, adding padding seems just fine.
> >
> I would rather see size as u64. Who's using raw today anyway?

the tracepoint stuff does

