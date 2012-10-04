Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2JDULM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:11:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:51069 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab2JDULL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:11:11 -0400
Message-ID: <1349381456.4260.50.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2012 06:10:56 +1000
In-Reply-To: <CA+55aFxbzeNG=sAQvPcE56rEpAbACqM04m2s73BzXVgK+PCnaQ@mail.gmail.com>
References: <1349339900.4260.10.camel@pasglop>
	 <CA+55aFxbzeNG=sAQvPcE56rEpAbACqM04m2s73BzXVgK+PCnaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 09:00 -0700, Linus Torvalds wrote:
> So this happens if you have "reverse merges" (ie you've pulled my
> tree, or some other tree I've pulled), and there is no longer a single
> clear common point that you started from. In that case, there is no
> simple diff for the "what has changed since that original point", and
> to get the diff for the merge you actually have to do the merge and
> check the end result. git-request-pull doesn't do that, it just
> assumes it's the simple case of some single common point.

That was more/less my guess. Thanks.

> The fact that you haven't seen it until now just means that you've
> generally done a good job at keeping your powerpc tree "clean" from
> other trees, and containing only your own work. 

Heh, yeah I try to :-) In this specific case, this was a topic branch
from Bjorn which some pre-requisite patches to the generic PCI code that
Gavin did to allow us to get rid of some custom resource allocation
crap, so the "getting rid of" had a dependency on that topic branch.

Unfortunately, Bjorn had also based that branch on top of some larger
cleanup patch so I ended up pulling that as well from him, which tripped
the whole thing.

Cheers,
Ben.


