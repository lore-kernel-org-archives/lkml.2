Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab0D0Qgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:36:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab0D0Qgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:36:38 -0400
Date: Tue, 27 Apr 2010 09:35:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Lindgren <tony@atomide.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] omap fixes for v2.6.34-rc5
In-Reply-To: <20100427161217.GB7225@atomide.com>
Message-ID: <alpine.LFD.2.00.1004270934220.3739@i5.linux-foundation.org>
References: <20100426190005.GJ7225@atomide.com> <alpine.LFD.2.00.1004270831430.3739@i5.linux-foundation.org> <20100427161217.GB7225@atomide.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, Tony Lindgren wrote:
> 
> OK point taken. I should have dealt with this earlier. Will only queue
> regressions after -rc3 or so.

Note that the "only regressions" is certainly not a hard rule. Anything 
that would be valid for -stable is obviously always valid: security 
issues, major oopses etc etc.

But the "only regressions" should kind of be the guiding line, and the 
others are more like "this is so serious that it should go in regardless 
of anything else".

			Linus
