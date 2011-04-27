Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1D0UE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:04:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50920 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1D0UE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:04:57 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JZkBfICjAAico3CUu5oA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <BANLkTi=xRJ+rRRpYWuLxtRiLfYZwsBU0vQ@mail.gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
	 <1303926576.18763.75.camel@gandalf.stny.rr.com>
	 <4DB86163.2070201@zytor.com>
	 <BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>
	 <1303931761.18763.101.camel@gandalf.stny.rr.com>
	 <BANLkTi=xRJ+rRRpYWuLxtRiLfYZwsBU0vQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 16:04:54 -0400
Message-ID: <1303934694.18763.112.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:38 +0300, Pekka Enberg wrote:

> To be honest, I don't think the arguments for streq() are that strong
> but I wanted to point out that the arguments against it weren't all
> that great either...

And I totally agree with you here. To be honest myself, I'm not set on
having streq() in the kernel. I'm perfectly happy doing the strcmp()==0
method. If someone were to get it into the kernel I would be happy to
convert to it.

But like you, I don't think the strong NACKs were justified. It was a
lot of hand waving why we should not have it in the kernel. If the
argument against streq() is simply that the arguments are not strong
enough to add it, and there's no real evidence that it fixes bugs, then
sure, I'll buy that. And I've been stating from the beginning that this
is all a preference thing. I'm guessing that we have probably the same
amount for it as against it, so I'm against a full conversion to it. But
this talk of it changing the C language is a bunch of bull. It's no
different than having printk() instead of printf().

-- Steve


