Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2IJRmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:42:50 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:51306 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab2IJRmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:42:49 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Another tree for "next"
References: <m3obli3j7a.fsf@intrepid.localdomain>
	<20120910100144.dcbe2715cde0fea51345a354@canb.auug.org.au>
Date: Mon, 10 Sep 2012 19:42:44 +0200
In-Reply-To: <20120910100144.dcbe2715cde0fea51345a354@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 10 Sep 2012 10:01:44 +1000")
Message-ID: <m31ui9g4ff.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

>> could you please add the following to your "next" tree?
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git  branch: next

> Could you be a bit more clear about what will be in that tree, please?
> Also when you repost this request, please post it a bit more widely among
> other people/lists who may be interested in this work.  Remember that
> linux-next is really only for stuff that is ready for Linus to pull into
> the next merge window (or bug fixes).  Also, would this tree be pulled
> directly by Linus, or via some other tree?

My plan is to merge all the stuff I'm (eventually) working on in the
above tree. For now - mostly IXP4xx (ARM CPU etc.) stuff which goes to
Linus, and (from time to time) WAN network drivers pulled by Dave. BTW
this includes both current fixes (for "this") and true "next" changes.

All of this is low profile and will be frequently empty.

Hope that's ok. Alternatively I can add separate trees/branches
(currently I'm only working on IXP4xx, at least as far as we're talking
about pullable git trees). Just wanted to minimize effort needed on
your side.

Not sure about these other people/lists, added lkml.
-- 
Krzysztof Halasa
