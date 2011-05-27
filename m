Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1E0MWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:22:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33374 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1E0MWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:22:07 -0400
Subject: Re: [GIT PULL] omap updates for 2.6.40
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20110527110416.GG27962@atomide.com>
Date: Fri, 27 May 2011 14:22:02 +0200
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F1227659-7B2E-4DAE-A160-9B64CE275FE6@dominion.thruhere.net>
References: <20110526113905.GG27250@atomide.com> <9741DC43-3197-4ECE-A377-FA865A3F6710@dominion.thruhere.net> <20110527063304.GA27962@atomide.com> <20110527110416.GG27962@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 27 mei 2011, om 13:04 heeft Tony Lindgren het volgende geschreven:

> * Tony Lindgren <tony@atomide.com> [110527 09:29]:
>> * Koen Kooi <koen@dominion.thruhere.net> [110526 19:02]:
>>> 
>>> Op 26 mei 2011, om 13:39 heeft Tony Lindgren het volgende geschreven:
>>> 
>>>> Hi Linus,
>>>> 
>>>> Please pull omap updates for this merge window from:
>>>> 
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus
>>>> 
>>>> This contains clean-up to shrink down omap specific code a bit. Also included
>>>> are some fixes. But basically no new code at this point.
>>> 
>>> What about updates to board files? Like adding support for the xM rev C to board-omap3beagle.c.
>> 
>> Sorry we're doing only code coalescing and fixes for this merge window as
>> discussed on LAKML. Otherwise it's hard to see the code coalescing in the
>> diffstats, so new code will need to wait a bit.
>> 
>> I'll take a look and see if we can justify some fix like trivial patches
>> like the revision detection patches during the -rc cycle.
> 
> Koen, the patch above needs to be refreshed to apply to current mainline
> kernel. It also seems to contain some whitespace errors.
> 
> Care to refresh it and repost?

I'm refreshing it right now and will after testing.

regards,

Koen