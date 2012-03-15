Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2CORWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:22:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21382 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2CORWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:22:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 108.39.66.94
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/XP2ubI0F3N1v+hHRQoHEkeC1QjrOpvwQ=
Date: Thu, 15 Mar 2012 13:22:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Michael Walle <michael@walle.cc>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (arm-soc tree related)
Message-ID: <20120315172213.GC20243@titan.lakedaemon.net>
References: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
 <20120315002020.GA16189@titan.lakedaemon.net>
 <201203151639.38223.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203151639.38223.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:39:38PM +0000, Arnd Bergmann wrote:
> On Thursday 15 March 2012, Jason Cooper wrote:
> > That's my mistake.  I did a pull request for the wrong branch.  Olof,
> > could you please drop the offending branch and I'll submit a new pull
> > request once I have a chance to test Arnd's irq patch?
> 
> I reverted this in the for-next branch for now. The two initial patches
> from the kirkwood/board branch are still present.

Okay, thanks.  I've rebased onto next/boards and merged the
depends/irqdomain branch.  I'm making progress, but not finished yet.

How is a pull-request done in the above scenario?  is my merge commit
included in the series?  what is the pull-request based on?
next/boards, or depends/irqdomain?

thx,

Jason.
