Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1ANCRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:17:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40957 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1ANCRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:17:32 -0500
Date: Fri, 14 Jan 2011 02:17:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20110114021724.GS19804@ZenIV.linux.org.uk>
References: <20110114104310.d975c69c.sfr@canb.auug.org.au>
 <AANLkTi=auk_ejRxzSj-bbFJz4gTCfK79qRe8JeFH2T8z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=auk_ejRxzSj-bbFJz4gTCfK79qRe8JeFH2T8z@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 05:24:17PM -0800, Linus Torvalds wrote:
> On Thu, Jan 13, 2011 at 3:43 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > While building Linus' tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> 
> Ok, I applied the attached, which makes it all build. I don't actually
> have a ecryptfs filesystem to test with, though.
> 
> Bad Al. Bad, bad Al.

Yeah...  Commit with summary "foldme" that got lost when reordering the
branch ;-/  My apologies.
