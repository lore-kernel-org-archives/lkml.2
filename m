Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0DOLmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:42:40 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51134 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0DOLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:42:38 -0400
Date: Thu, 15 Apr 2010 12:41:47 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Avi Kivity <avi@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Ralf Baechle <ralf@linux-mips.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
Message-ID: <20100415114146.GA10863@shareable.org>
References: <20100406133026.GD20577@parisc-linux.org> <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com> <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org> <20100326175827.GD20055@linux-mips.org> <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org> <17213.1271245760@redhat.com> <3879.1271321292@redhat.com> <4BC6D334.8050607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC6D334.8050607@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Likely.  But we haven't tested all current and future x86 clones, and 
> they may be based off the Intel documentation instead of the AMD 
> documentation.

I wonder about that too.  I got the impression Transmeta did lots of
testing real x86s in all sorts of corner cases, because the manuals
don't cover everything that the broad base of software depends on in
practice.  Clone makers have to do it to a much higher standard than
emulators because you can't generally release patches...

I think Via (including whatever the CPU line was formerly called)
have been bitten a few times by not quite matching software
expectations.

Even Intel was caught on x86_64 at the beginning by slight differences
when they cloned AMD's design :-)

-- Jamie
