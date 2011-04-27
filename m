Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab1D0Svv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:51:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63544 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab1D0Svt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Kbscz/zd+MViMz52Q7oEBSyb4O56ixe+jNBRw8X9XL/dTbro0kaKchiWTaza/yY8cg
         Uzho6JznmbpSUYnKQbJ3Y3SzflbdH5PYAImzsab+peycvIA4R1xAtkN/pRx0uPXEvHsl
         xC/54OI+8o1VDjql9h/AqqaqlTv/b10w+sVMY=
MIME-Version: 1.0
In-Reply-To: <4DB86163.2070201@zytor.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
	<1303926576.18763.75.camel@gandalf.stny.rr.com>
	<4DB86163.2070201@zytor.com>
Date: Wed, 27 Apr 2011 21:51:48 +0300
X-Google-Sender-Auth: y4MIA238SE_449mNuRuhwAF-nE0
Message-ID: <BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Pekka Enberg <penberg@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 9:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Because !strcmp() is idiomatic C.
>
> This is the same kind of stupidity as
>
> #define BEGIN {
> #define END   }

No it's not.

It's the same kind of API extension kstrdup(), for example, is.
Whether or not we should it do it is a separate matter and I think the
only reasonable argument for and against is whether it (a) reduces the
number of bugs, (b) improves code readability significantly, or (c)
generates better code.

                        Pekka
