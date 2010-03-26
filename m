Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0CZR6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:58:39 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37898 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0CZR6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:58:38 -0400
Date: Fri, 26 Mar 2010 18:58:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
Message-ID: <20100326175827.GD20055@linux-mips.org>
References: <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org>
 <20100326144241.8583.95617.stgit@warthog.procyon.org.uk>
 <28287.1269625325@redhat.com>
 <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:45:05AM -0700, Linus Torvalds wrote:

> I went back and checked the old Intel 386 docs from -92 or something, and 
> it was "undefined" in there too. So at least Intel seems to have been very 
> consistent on this.
> 
> That said, maybe all implementations actually do the "don't touch" thing. 
> 
> But I do have this memory of us doing this ten+ years ago, though, and 
> having to check the ZF after all. Which is why I reacted to the patch in 
> the first place and checked the documentation.

My trusty old 486 book [1] in the remarks about the BSF instruction:

"The documentation on the 80386 and 80486 states that op1 is undefined if
op2 is 0.  In reality the 80386 will leave the value in op1 unchanged.
The first versions of the 80486 will change op1 to an undefined value.
Later version again will leave it unchanged."

[1] Die Intel Familie in German language, by Robert Hummel, 1992
