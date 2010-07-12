Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0GLR4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:56:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40169 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab0GLR4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:56:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3B572C.4070705@s5r6.in-berlin.de>
Date: Mon, 12 Jul 2010 19:55:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <201007111651.42963.Martin@lichtvoll.de> <20100711172252.GA3379@1wt.eu> (sfid-20100711_193037_169001_8F8BE25C) <201007121744.05844.Martin@lichtvoll.de>
In-Reply-To: <201007121744.05844.Martin@lichtvoll.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Bugzilla severity and priority fields or something similar could be used to 
> set the importance of a bug report and the regression list could be sorted 
> by importance. One important criterion also would be whether someone could 
> confirm it, reproduce it. Even when I reported those desktop freezes, 
> unless someone confirmed them it might just happen for me. Well a "confirm" 
> or vote button might be good, so that the amount of confirmations could be 
> counted. 

"I can reproduce it" comments are often very helpful.  "It is important
to me (and it should be to you too)" comments perhaps not so much.

If a bug doesn't make any progress, it may be because the cause of the
bug (i.e. which subsystem is at fault or when the bug was introduced) is
not known well enough.  In such a case, more reproducers won't really
help (let alone stating that it is important to somebody); then somebody
needs to delve deeper into it and narrow the cause further down.

A bug which can be reproduced by several people is usually a bug that
can be reproduced quite reliably, and hence is a bug whose cause can
likely be found by bisection.  A bug report with a to be blamed git
commit ID attached (at least as far as the reporter could determine),
Cc'd to author and committer of that commit, has more chances to get
fixed quicker than others.

So, votes don't help IMO; good reports do.  And the reports need to be
early enough --- i.e. somebody needs to run -rc kernels --- since coming
up with a fix, validating the fix, and merging it may take time.

If there is little progress on a regression for which at least the
faulty subsystem is known, and the release goes by, the merge window
opens, and you see a pull request for that subsystem, then reply to that
pull request with a friendly reminder that there is still an unresolved
regression in that subsystem waiting for attention.

[...]
> As told already I will rebalance my decision on which kernel to use.

If or when you cannot spare resources to test a kernel yourself (be it
Linus' final release, or an -rc, not to mention linux-next), you can
also look out for Raphael's regression lists around the time of a final
release, to get a picture whether it is a worse or better one.
-- 
Stefan Richter
-=====-==-=- -=== -==--
http://arcgraph.de/sr/
