Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1FMLpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:45:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1FMLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:45:16 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=h5P9cAk6s4UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=xy2H-zEzVo-4mT_4y5wA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 01/15] tracing: Schedule a delayed work to call wakeup()
From: Steven Rostedt <rostedt@goodmis.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <BANLkTi=0ckkC0SXhE9xKsh4hx-pzYh3hPw@mail.gmail.com>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172910.425793191@goodmis.org> <20110613100713.GA30962@elte.hu>
	 <BANLkTi=0ckkC0SXhE9xKsh4hx-pzYh3hPw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 07:45:15 -0400
Message-ID: <1307965515.9218.60.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 13:27 +0300, Pekka Enberg wrote:
> On Mon, Jun 13, 2011 at 1:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> +     const unsigned long delay = msecs_to_jiffies(2); //delay 2 ms
> >
> > We don't do C++ comments in the kernel ...
> 
> Heh, we also don't do pointless comments like the one above! ;-)

Right! I'll strip it.

-- Steve


