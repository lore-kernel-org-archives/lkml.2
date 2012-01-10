Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2AJSpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:45:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47880 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211Ab2AJSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:45:33 -0500
Date: Tue, 10 Jan 2012 18:45:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: Regulator updates for 3.3
Message-ID: <20120110184530.GE7164@opensource.wolfsonmicro.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com> <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 10:27:01AM -0800, Linus Torvalds wrote:

> Just don't do it. There's no excuse. The *only* time you should merge
> is when a sub lieutenant asks you to - and if you have people who work
> with you and ask you to do pointless merges almost every day, just
> tell them to shut the f*ck up already!

Hrm, OK.  These merges are all merges up of bug fixes for -rc from my
own tree into the development code which I tend to do constantly to make
it easier to work directly on the development branch.  What's the best
practice here - push things to you a bit more aggressively and wait
until you've tagged a -rc and then merge that back up into the
development branch?

> Do your development in a real branch, and do sane things in that real
> branch - like pulling from the people who work with you, but only when
> they ask, and only when they are ready.  And applying patches. But
> never *ever* have those stupid pointless "Merge remote-tracking branch
> 'regulator/for-linus' into regulator-next" in the branch you actually
> use for development, and the branch you send to me.

The -next branch is the branch used for development here unless there's
anything that's actually a topic that might want to get viewed
separately (like the device tree stuff this time), and all the merges
are from my own trees.  The reason they showed up as merges from remotes
is an oddity of my workflow here.
