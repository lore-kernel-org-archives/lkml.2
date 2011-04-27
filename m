Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab1D0Sdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:33:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51441 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab1D0Sdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:33:39 -0400
Message-ID: <4DB86163.2070201@zytor.com>
Date: Wed, 27 Apr 2011 11:33:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com> <1303926576.18763.75.camel@gandalf.stny.rr.com>
In-Reply-To: <1303926576.18763.75.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 10:49 AM, Steven Rostedt wrote:
> On Tue, 2011-04-26 at 16:45 -0300, Thiago Farina wrote:
>> This macro is arguably more readable than its variants:
>> - !strcmp(a, b)
>> - strcmp(a, b) == 0
> 
> Actually, this was proposed way back in 2002 my Rusty and I did not see
> anyone arguing against it. I wonder why it never was incorporated back
> then?
> 
> http://marc.info/?l=linux-kernel&m=103284339813100&w=2
> 
> [ added Cc's of some of those that replied to this thread ]
> 

Because !strcmp() is idiomatic C.

This is the same kind of stupidity as

#define BEGIN {
#define END   }

It doesn't matter if it is more readable *to you*... learn the language,
please.

	-hpa
