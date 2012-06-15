Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2FOA4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:56:35 -0400
Received: from linux-sh.org ([111.68.239.195]:58518 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2FOA4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:56:33 -0400
Date: Fri, 15 Jun 2012 09:56:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20120615005621.GE22007@linux-sh.org>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
 <20120614030606.GC27673@linux-sh.org>
 <20120614034036.GE27673@linux-sh.org>
 <20120615101407.369c754da872e18c854ab481@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615101407.369c754da872e18c854ab481@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:14:07AM +1000, Stephen Rothwell wrote:
> On Thu, 14 Jun 2012 12:40:36 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
> > Ok, it's because the asm-generic/bug.h __ASSEMBLY__ guarding is
> > completely bogus. This should hopefully fix it once and for all.
> > Sorry for the trouble.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Can you create a proper commit message and send this to Linus, please?  I
> have included it in my fixes tree in linux-next for today.
> 
Will do, thanks for testing.
