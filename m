Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab1D0XiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:38:16 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47738 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760332Ab1D0XiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:38:12 -0400
Date: Wed, 27 Apr 2011 19:38:00 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427233800.GB5364@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
 <1303926576.18763.75.camel@gandalf.stny.rr.com>
 <4DB86163.2070201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB86163.2070201@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:33:07AM -0700, H. Peter Anvin wrote:
> 
> Because !strcmp() is idiomatic C.
> 
> This is the same kind of stupidity as
> 
> #define BEGIN {
> #define END   }
> 
> It doesn't matter if it is more readable *to you*... learn the language,
> please.

Interesting bit of trivia:  This sort of nonsense[1] is what inspired
the the International Obfuscated C Code Contest[2].  :-)

[1] http://minnie.tuhs.org/cgi-bin/utree.pl?file=V7/usr/src/cmd/sh/mac.h
[2] http://www.ioccc.org/faq.html

						- Ted
