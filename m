Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0LMDu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:50:26 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14328 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab0LMDuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:50:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJskBU15LdLl/2dsb2JhbACjf3nBCoVKBA
Date: Mon, 13 Dec 2010 14:50:21 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nick Piggin <npiggin@kernel.dk>, Ed Tomlinson <edt@aei.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-ID: <20101213035021.GA8057@amd>
References: <20101213023733.GB6522@amd>
 <201012122153.33427.edt@aei.ca>
 <20101213025910.GA6981@amd>
 <20101213144555.17aa7826.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213144555.17aa7826.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 02:45:55PM +1100, Stephen Rothwell wrote:
> Hi Nick,
> 
> On Mon, 13 Dec 2010 13:59:10 +1100 Nick Piggin <npiggin@kernel.dk> wrote:
> >
> > On Sun, Dec 12, 2010 at 09:53:32PM -0500, Ed Tomlinson wrote:
> > > 
> > > I get this when building:
> > > 
> > > security/security.c: In function 'security_inode_exec_permission':
> > > security/security.c:520: error: 'rcu' undeclared (first use in this function)
> > > security/security.c:520: error: (Each undeclared identifier is reported only once
> > > security/security.c:520: error: for each function it appears in.)
> > > make[1]: *** [security/security.o] Error 1
> > > make: *** [security] Error 2
> > > 
> > > Missing include maybe?
> > 
> > Ah, missed permutation while doing a final build check. `rcu` should
> > just be renamed to `flags`.
> 
> You will, of course never put anything not build tested into a tree for
> linux-next inclusion, right?  ;-)

Right. It will be guaranteed to have been build tested with at least
one .config :)

Which reminds me, I haven't done an allmodconfig recently to see if
I've missed exports...

