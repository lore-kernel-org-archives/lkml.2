Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1D1AGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:06:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1D1AGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:06:03 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=eyoELzJebOAUyCIMRVgA:9 a=kFX5o7QLZMGu7W3F7J8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110427214657.GE9487@ZenIV.linux.org.uk>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110427164639.GD9487@ZenIV.linux.org.uk>
	 <1303924079.18763.70.camel@gandalf.stny.rr.com>
	 <20110427214657.GE9487@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 20:05:59 -0400
Message-ID: <1303949159.18763.120.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:46 +0100, Al Viro wrote:

> That's the whole fucking _point_; adding random extensions to the language
> leads to the place where Pascal and LISP are and it's not pretty.  Each
> might make sense taken separately (hell, bzero(3) would prevent real, honest
> to Cthulhu bugs - it's memset(p, 0, n) and we had memset-with-swapped-arguments
> bugs fairly often and yes, in our tree most of memset() callers do pass '\0'
> as the second argument).  Pile enough of those together and you've got yourself
> a dialect only you understand.  _Bad_ idea, since the next thing that happens
> is different dialects in different parts of tree.  And the end of non-incestous
> code review and fixes.  I've seen it first-hand (OK, second - I had enough
> sense to stay out of that particular clusterfuck) on Algol 68 codebase.  I
> *really*, *really* do not want to see anything similar ever again.  Especially
> on projects I can't just piss upon and walk away from.  The fact that in C
> you *can* extend the language that way doesn't make it a good idea.
> 

So in translating the above I have:

"Don't do this because you are opening up a door that will lead to
extension hell"

Am I correct?

If I am, then I will take that as a reason not to add it and leave it at
that.

-- Steve


