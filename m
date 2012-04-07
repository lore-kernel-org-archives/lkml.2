Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2DGHLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:11:35 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52964 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2DGHKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:10:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] GPIO changes for v3.4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFwN_=5UH0KrcnSUONxgfTtkmA45ND8Rq1n0tUv6+_-1hw@mail.gmail.com>
References: <CACxGe6s1GFkqgxsbKQWQxcoJZjTkkFHbAv3tqK2cPn6tho502w@mail.gmail.com> <CA+55aFwN_=5UH0KrcnSUONxgfTtkmA45ND8Rq1n0tUv6+_-1hw@mail.gmail.com>
Date: Fri, 06 Apr 2012 20:22:41 -0700
Message-Id: <20120407032241.B2F753E2155@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 14:08:22 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Mar 27, 2012 at 12:20 AM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
> >
> > Please pull.
> 
> You should double-check my trivial sleep control merge of the gpios vs
> regulator code. It looked like a trivial context merge, but there may
> be some subtle interactions on the actual device side that I have no
> idea of. The author for both was the same, though, so I assume they
> work together.

It looks right to me.  Laxman, can you test and verify that everything
is working correctly with Linus' current tree?  See the merge Linus
made in commit 7bf97e1d5, "Merge tag 'gpio-for-linus' of
git://git.secretlab.ca/git/linux-2.6"

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
