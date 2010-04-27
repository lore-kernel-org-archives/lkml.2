Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0D0PdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:33:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228Ab0D0Pc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:32:58 -0400
Date: Tue, 27 Apr 2010 08:31:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Lindgren <tony@atomide.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] omap fixes for v2.6.34-rc5
In-Reply-To: <20100426190005.GJ7225@atomide.com>
Message-ID: <alpine.LFD.2.00.1004270831430.3739@i5.linux-foundation.org>
References: <20100426190005.GJ7225@atomide.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 26 Apr 2010, Tony Lindgren wrote:
> 
> Please pull omap fixes from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

I pulled it this time, but I'm starting to get really irritated with you.

These look like real fixes, but quite frankly, by -rc5, that IS NOT 
ENOUGH. 

They need to be _regressions_, not just cleanups and fixes for things that 
have never worked. And this is starting to be a pattern with the omap 
tree: you're not honoring the merge window properly.

Just "it's a bug-fix" or "it's deleting unused code" is not enough. The 
point of the late -rc series is to fix problems from the merge window, not 
add new changes. I realize that you think that all the new changes are 
obviously good, but the fact is, bugs happen even in "obvious bug-fixes". 

And that's why we have the rule about late-rc pulls being about 
_regressions_ and/or major oopses/security issues. Not just random 
development that are meant to improve things.

		Linus
