Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2JRD10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:27:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34813 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2JRD1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <87txtso9xw.fsf@rustcorp.com.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <87txtso9xw.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 20:27:03 -0700
X-Google-Sender-Auth: C_T3uqfOgc6IZKcUwUB4T4PZk7g
Message-ID: <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 6:17 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> You cut too much: you need genkeyid.

Yeah, I sent out a fixed version later, but I much prefer your version
that generates those files earlier, not a "make modules_install".

[ Btw, your email "Date:" field is from 2+ hours ago, but it hit
ozlabs and then arrived here only minutes ago. There's some delay in
your mail delivery. Maybe it's something you know about, and you're
batching emails over carrier pigeons, but I thought I'd mention it in
case you weren't aware of some odd SMTP delay ]

> And in a moment of optimism I tried 'make modules_install MODLIB=.' to
> sign modules in-place.  It deleted my kernel/ dir.  Don't recommend.

Heh. I assume that's an old "feature", not something that has anything
to do with the whole signing thing.

            Linus
