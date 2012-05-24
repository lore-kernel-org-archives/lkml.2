Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2EXIIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:08:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44166 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2EXIH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:07:59 -0400
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBQDpoQChAB_GmhuGStPEdjGUVkAg5cE=zH143L9u8pN-A@mail.gmail.com>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	 <1337844471.9783.48.camel@laptop>
	 <CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	 <1337845936.9783.57.camel@laptop> <1337846272.9783.59.camel@laptop>
	 <CABPqkBQDpoQChAB_GmhuGStPEdjGUVkAg5cE=zH143L9u8pN-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 10:07:53 +0200
Message-ID: <1337846873.9783.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 10:00 +0200, Stephane Eranian wrote:
> On Thu, May 24, 2012 at 9:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2012-05-24 at 09:52 +0200, Peter Zijlstra wrote:
> >>
> >> OK, so how about I queue the below and if the u-code updates gets
> >> released before this hits Linus' tree we'll make it all go away ;-)
> >>
> > Also, I suspect the u-code update might make INST_RETIRED.ANY_P
> > available on SNB again voiding the need to use a different encoding. But
> > we'll cross that bridge when we'll get to it.
> 
> The PREC_DIST is by design, it is not a work-around of any sort.
> It is an attempt at getting a better distribution of samples when sampling
> with inst_retired.

Oh completely agreed, note that my patch used UOPS_RETIRED.ALL. Only
Namhyung used PREC_DIST, mostly I suspect because he's not stared at all
these manuals for long yet ;-)

