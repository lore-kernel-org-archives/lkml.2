Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0CZRw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:52:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58250 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0CZRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:52:27 -0400
Date: Fri, 26 Mar 2010 11:52:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
Message-ID: <20100326175226.GO3875@parisc-linux.org>
References: <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28287.1269625325@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 05:42:05PM +0000, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Where did you find that "doesn't modify its output" thing? It's not true. 
> > The truth is that the destination is undefined. Just read the dang Intel 
> > documentation, it's very clearly stated right there.
> 
> Hmmm...  My ancient Borland Assembler dead-tree manual doesn't mention that.

The only x86 manuals I have are encased in the Itanium SDM from 2002,
and they agree with Linus that BSF and BSR undefine the contents of the
destination operand if the source operand contains zero.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
