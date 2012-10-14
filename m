Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2JNAei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 20:34:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35684 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2JNAeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 20:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <11002.1350125310@warthog.procyon.org.uk>
References: <11002.1350125310@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Oct 2012 17:34:15 -0700
X-Google-Sender-Auth: PF7BOTobIbZIu18Lf6TP1dN-Ghc
Message-ID: <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
Subject: Re: [GIT PULL] UAPI disintegration for include/linux/{,byteorder/}*.h
To: David Howells <dhowells@redhat.com>
Cc: paulus@samba.org, davem@davemloft.net, jaxboe@fusionio.com, tj@kernel.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
 I want to make it very clear that if you *ever* suggest another big
include file cleanup, I will say "f*ck no" and block you from my
emails forever. Ok? So don't bother. We're done with these kinds of
games. Forever. It's not worth it, don't ever suggest it again for
some other "cleanup".

In the meantime, please fix the fact that "tools/perf" broke. I
suspect the only way to fix it is to teach perf to be compiled with
the proper "-I" incantation and a lot of header file changes. Right
now it uses things like

   #include "../../../include/linux/perf_event.h"

which was broken by this pull. Sadly, I noticed too late, and the
broken mess is long pushed out.

              Linus
