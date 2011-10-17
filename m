Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1JQUF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:05:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1JQUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:05:26 -0400
X-Authority-Analysis: v=1.1 cv=G2mrdTwFgeQf4gnIVCGl5REDSA/JVLCrZmxI9r5hHjY= c=1 sm=0 a=rBmysYqC3NUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=meVymXHHAAAA:8 a=vrFvb1KfFP_rWzRdzIIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318881923.4722.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hirokazu Takata <takata@linux-m32r.org>
Date: Mon, 17 Oct 2011 16:05:23 -0400
In-Reply-To: <20111017194030.GA6502@elte.hu>
References: <20111017174938.842273454@goodmis.org>
	 <20111017185440.GB5545@elte.hu>
	 <1318878632.4722.6.camel@gandalf.stny.rr.com>
	 <20111017194030.GA6502@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 21:40 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 2011-10-17 at 20:54 +0200, Ingo Molnar wrote:
> > 
> > > How about the m32r build fix? I think we should apply it to 
> > > perf/core if everyone else was fine with your fix.
> > 
> > Hmm, I saw a notice that Andrew pulled it into his -mm tree. Is it 
> > going that way?
> 
> No. It must go into perf/core to not open up a wide bisection 
> breakage window. So please apply if it everyone is happy with it.
> 

I could add it, but we should have an Acked-by from Hirokazu Takata.

I would also be interested in knowing if the latest kernel is running on
any m32r hardware at the moment? There doesn't look to be much
development on the m32r arch.

-- Steve


