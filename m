Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2BAN16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:27:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2BAN14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:27:56 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=f6_CTDm5gc9VdVHFTJoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328102874.5882.62.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 08:27:54 -0500
In-Reply-To: <87y5snhwwd.fsf@rustcorp.com.au>
References: <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
	 <1327588606.22710.100.camel@gandalf.stny.rr.com>
	 <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au>
	 <1327924333.22710.157.camel@gandalf.stny.rr.com>
	 <87sjiwjzew.fsf@rustcorp.com.au> <20120131122016.GF32010@elte.hu>
	 <1328014230.5882.29.camel@gandalf.stny.rr.com>
	 <87y5snhwwd.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 17:18 +1030, Rusty Russell wrote:

> Here's the results I get, using the Ubuntu 3.0.0 config (minus
> CONFIG_DEBUG_INFO, and rest with Enter held down).
> 
> Applied,
> Rusty.
> 

Thanks Rusty!


I originally had this in my own local git queue ready to be pushed to
Ingo after I get your Ack. But I think it is better if this change goes
through you. I'll take this change out and rebase, as none of my other
work depends on it.

Thanks again!

-- Steve


