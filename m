Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2EDLVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:21:35 -0400
Received: from websrv.saout.de ([78.46.99.52]:54253 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2EDLVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:21:34 -0400
Message-ID: <1336130491.3771.0.camel@localhost>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: Jana Saout <jana@saout.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 04 May 2012 13:21:31 +0200
In-Reply-To: <CA+55aFyM0G9wthCu5rm=N6MQN4qRhRc_yXH4dB4Z1tJs_yqrJg@mail.gmail.com>
References: <1335788867.29087.19.camel@localhost>
	 <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
	 <1335875321.26671.15.camel@localhost>
	 <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
	 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
	 <20120503064722.GN6871@ZenIV.linux.org.uk>
	 <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
	 <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
	 <4FA2CAD9.6010808@zytor.com>
	 <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
	 <1336077035.3676.5.camel@localhost> <1336079020.7467.0.camel@localhost>
	 <CA+55aFyM0G9wthCu5rm=N6MQN4qRhRc_yXH4dB4Z1tJs_yqrJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Both of the early patches had the same issue, and didn't cover
> __d_lookup(). I had simply forgotten about it, partly because
> __d_lookup() didn't use the other helper functions from
> asm/word-at-a-time.h.
> 
> So run the later patch, together with the incremental change on top of
> it for just the __d_lookup() case.
> 
> Or take the patch from this email, which has all the changes,
> including the asm simplification that we talked about with Peter. It
> also has an optimistic "tested-by" line from you already ;)

... which seems justified.  No oopses or other weird behavior -
everything looks fine now. :)

Thanks,
	Jana


