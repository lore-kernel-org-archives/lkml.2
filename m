Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2HPKsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:48:47 -0400
Received: from ozlabs.org ([203.10.76.45]:57128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2HPKsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:48:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Jonas Gorski <jonas.gorski@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: fix module.c build for 32 bit
In-Reply-To: <1171.1345019698@warthog.procyon.org.uk>
References: <87ipckrgal.fsf@rustcorp.com.au> <87d32us55c.fsf@rustcorp.com.au> <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com> <31154.1344872382@warthog.procyon.org.uk> <32504.1344953290@warthog.procyon.org.uk> <1171.1345019698@warthog.procyon.org.uk>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 16 Aug 2012 20:10:25 +0930
Message-ID: <87a9xvce7a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012 09:34:58 +0100, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > For a build fix????
> 
> Linux hasn't pulled the asm-generic cleanup patch yet - you missed the merge
> window, I think.  Jonas detected the problem in linux-next.

Yes, I missed the window but asked Linus to pull anyway.  Was delaying
for the other module patch, left it too long.

This cleanup won't benefit from more stewing in linux-next, since it sat
there for quite a while already.  Feel free to add my Acked-by and push
it straight to Linus, otherwise I'll roll them together for next window.

Thanks,
Rusty.
