Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2GOL1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 07:27:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34552 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GOL1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 07:27:43 -0400
Date: Sun, 15 Jul 2012 12:27:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the signal tree with the arm-current
 tree
Message-ID: <20120715112735.GI31729@ZenIV.linux.org.uk>
References: <20120705173526.bf8772adb18edfc91adddea8@canb.auug.org.au>
 <20120705075204.GA12344@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705075204.GA12344@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:52:04AM +0100, Russell King wrote:
> On Thu, Jul 05, 2012 at 05:35:26PM +1000, Stephen Rothwell wrote:
> > Hi Al,
> > 
> > Today's linux-next merge of the signal tree got a conflict in
> > arch/arm/kernel/signal.c between commit f73e2ca64281 ("ARM: 7443/1:
> > Revert "new way of handling ERESTART_RESTARTBLOCK"") from the arm-current
> > tree and commits 9c802c169f96 ("arm: deal with handlerless restarts
> > without leaving the kernel") and 76c3f4da3ee4 ("arm: get rid of
> > TIF_SYSCALL_RESTARTSYS") from the signal tree.
> > 
> > I have no idea how to cope with this.  So I have effectively reverted
> > commit f73e2ca64281 ("ARM: 7443/1: Revert "new way of handling
> > ERESTART_RESTARTBLOCK"") for today (though parts of that commit are also
> > implemented by the above signal tree commits).
> 
> Currently, bugs have been found with the signal handling updates which
> happened during the last merge window.
> 
> Will has concerns with Al's proposed fixes for the signal handling.

Could you please resend whatever concerns those had been my way?
The last I've seen from Will had been about the stuff in mainline,
not in -next; I might have missed something quite easily, though -
net.access had been really lousy lately and piles in l-k mbox... ouch.
