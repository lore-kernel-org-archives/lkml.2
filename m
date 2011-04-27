Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1D0UYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1D0UYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:24:53 -0400
Message-ID: <4DB87B74.80104@zytor.com>
Date: Wed, 27 Apr 2011 13:24:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Pekka Enberg <penberg@kernel.org>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>	 <1303926576.18763.75.camel@gandalf.stny.rr.com>	 <4DB86163.2070201@zytor.com>	 <BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>	 <1303931761.18763.101.camel@gandalf.stny.rr.com>	 <BANLkTi=xRJ+rRRpYWuLxtRiLfYZwsBU0vQ@mail.gmail.com> <1303934694.18763.112.camel@gandalf.stny.rr.com>
In-Reply-To: <1303934694.18763.112.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 01:04 PM, Steven Rostedt wrote:
> It's no different than having printk() instead of printf().

Which IMO was a mistake in Linux.  It would be different if the priority
argument had been explicit (although these days it's functionally
required, which sort-of justifies a different name.)

kmalloc(), kstrdup() etc. have different names because they're different
interfaces, which don't duplicate the malloc(), strdup() etc. semantics.

	-hpa
