Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0CTSDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:03:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0CTSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:03:43 -0400
Date: Sat, 20 Mar 2010 19:03:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
Message-ID: <20100320180336.GT20695@one.firstfloor.org>
References: <20100320023216.GA917@basil.fritz.box> <4BA4CE32.1020207@imap.cc> <20100320140710.GS20695@one.firstfloor.org> <4BA504DD.2060107@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA504DD.2060107@imap.cc>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 06:24:45PM +0100, Tilman Schmidt wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Am 2010-03-20 15:07 schrieb Andi Kleen:
> > The warning merely is intended to get people to think
> > about that. Yes it cannot enforce it directly.
> 
> Then change the wording, at least. With the current wording, people will
> think, "But I did!", and complain about a false positive on LKML, where
> they will be annoyed to learn that checkpatch.pl's criterion for
> "describing fully" is "having at least four lines".

Change to what?  If you have a better suggestion I can change it.

> 
> But even with a better wording, I think the warning will still do more
> harm than good.

We have to agree to disagree on that then.


> 
> > Yes it's not a perfect measure and can be circumvented. But hopefully
> > most users would not.
> 
> I'm not thinking of circumvention, but of well-meaning authors writing
> long explanations that describe everything the author found worth
> mentioning, but still don't answer the essential question: "Should I
> select that option?" In fact, most of the unhelpful Kconfig help texts
> I've encountered where longer than four lines. :-)

I don't disagree that longer help texts can be unhelpful too,
but at least there's some chance that they are. 

For a single sentence it's very unlikely ever that it's helpful.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
