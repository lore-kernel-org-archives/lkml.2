Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1DWHuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:50:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:57302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab1DWHuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:50:32 -0400
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, arun@sharma-home.net,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110423000347.GC9328@tassilo.jf.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	 <20110422092322.GA1948@elte.hu>
	 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	 <20110422105211.GB1948@elte.hu>
	 <20110422165007.GA18401@vps.sharma-home.net>
	 <20110422203022.GA20573@elte.hu> <20110422203222.GA21219@elte.hu>
	 <20110423000347.GC9328@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 23 Apr 2011 09:50:12 +0200
Message-ID: <1303545012.2298.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 17:03 -0700, Andi Kleen wrote:
> > > Yes, and note that with instructions events we even have skid-less PEBS 
> > > profiling so seeing the precise .
> >                                   - location of instructions is possible.
> 
> It was better when it was eaten. PEBS does not actually eliminated
> skid unfortunately. The interrupt still occurs later, so the
> instruction location is off.
> 
> PEBS merely gives you more information.

You're so skilled at not actually saying anything useful. Are you
perchance referring to the fact that the IP reported in the PEBS data is
exactly _one_ instruction off? Something that is demonstrated to be
fixable?

Or are you defining skid differently and not telling us your definition?

What are you saying?
