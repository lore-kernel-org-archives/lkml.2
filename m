Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0GKTtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 15:49:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59467 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab0GKTtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:49:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3A203F.4080203@s5r6.in-berlin.de>
Date: Sun, 11 Jul 2010 21:49:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, Lee Mathers <wwbbs2008@gmail.com>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com> (sfid-20100711_161032_809811_F0F1C0DA) <201007111651.42963.Martin@lichtvoll.de>
In-Reply-To: <201007111651.42963.Martin@lichtvoll.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> One reason for a demand for me is best expressed by this question: Does 
> the kernel developer community want to encourage that a group of advanced 
> Linux users - but mostly non-developers - compile their own vanilla or 
> valnilla near kernels, provide wider testing and report a bug now and 
> then?

Yes, testing is desired --- in order to shake out bugs that are not
manifest on the developer's systems.  Remember that the kernel is a
special program in which there are many classes of bugs that can only be
reproduced on special hardware and/or with special workloads.

Alas, there are not only new bugs in new features but also new bugs in
existing features, a.k.a. regressions.  But like new bugs, many
regressions can alas not be found by the developers themselves on their
test systems.

You mentioned two particular regressions in your initial posting.  Do
you have suggestions how they could have been prevented in the first
place?  Or how they could have been handled better than they were?

Do you see subsystems of the kernel in which regressions are not taken
as seriously as in other ones?

> Well Linus has at least been a bit more reluctant to take big changes 
> after rc1 this cycle, so maybe 2.6.35 will be better again.

2.6.35 will only be better if this (gradual) change of procedure means
that -rc kernels are going to be tested more and new bugs are going to
be found and fixed quicker in the -rc phase than before.  And 2.6.36+
will only be better if the stricter post -rc1 merges do not motivate
developers to put even more hastily assembled under-tested crap into
their pre -rc1 pull requests than they already do.

[PS: 2.6.34 works very well for me, as most 2.6.x releases do.]
[PS2:  When on lkml, please use reply-to-all, not reply-to-list-only.]
-- 
Stefan Richter
-=====-==-=- -=== -=-==
http://arcgraph.de/sr/
