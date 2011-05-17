Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1EQN1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:27:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65470 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1EQN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:27:12 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YxDa49jycvVWou2g-moA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, Ingo Molnar <mingo@elte.hu>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4DD2771E.70106@gmail.com>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>
	 <20110510084158.GC27426@elte.hu> <1305032797.2943.34.camel@frodo>
	 <20110511215111.GA16355@elte.hu>
	 <BANLkTikRX2gNwyUSWLNBcpc727Ww7Ya6Ow@mail.gmail.com>
	 <1305631152.5456.665.camel@gandalf.stny.rr.com>  <4DD2771E.70106@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 09:27:09 -0400
Message-ID: <1305638829.5456.725.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 07:24 -0600, David Ahern wrote:

> libparsevent or libperf? If you really meant libperf will it be a
> superset of the event parsing -- like the inclusion of the plugins infra?
> 

Yes, although not all the plugin infrastructure was in libparsevent.so.

I plan on taking libparsevent.so and adding perf wrappers to its
interface.

-- Steve


