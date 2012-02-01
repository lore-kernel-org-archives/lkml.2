Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2BAOZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:25:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2BAOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:25:08 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Tty9oNO6AAAA:8 a=meVymXHHAAAA:8 a=DNvn3mvtqgzobwZ5EhYA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328106305.5882.63.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 09:25:05 -0500
In-Reply-To: <20120201134943.GC28547@elte.hu>
References: <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
	 <1327588606.22710.100.camel@gandalf.stny.rr.com>
	 <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au>
	 <1327924333.22710.157.camel@gandalf.stny.rr.com>
	 <87sjiwjzew.fsf@rustcorp.com.au> <20120131122016.GF32010@elte.hu>
	 <1328014230.5882.29.camel@gandalf.stny.rr.com>
	 <87y5snhwwd.fsf@rustcorp.com.au> <20120201134943.GC28547@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 14:49 +0100, Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Applied,
> > Rusty.
> > 
> > From: Steven Rostedt <rostedt@goodmis.org>
> 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (made all out-of-line)
> 
> Steve's SOB seems to be missing.

Ah I may have never added it as it was originally just posted to get
Rusty's approval. So here it is:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thanks,

-- Steve


