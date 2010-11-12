Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0KLRVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:21:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:20453 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0KLRVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:21:34 -0500
Message-Id: <0d30dc$k5i5ji@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,188,1288594800"; 
   d="scan'208";a="676927090"
Date: Fri, 12 Nov 2010 17:21:19 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm fixes
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTik8-=Ku+4k0+KVZknAgx2zJGRo-n10jaNW-fke6@mail.gmail.com>
References: <alpine.DEB.2.00.1011110021320.12522@skynet.skynet.ie> <AANLkTik8-=Ku+4k0+KVZknAgx2zJGRo-n10jaNW-fke6@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Nov 2010 08:24:48 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> But when you cherry-pick it from some random internal tree that nobody
> will necessarily ever see, and that you don't even describe what it
> is, it's only pure confusion. I do
> 
>   [torvalds@i5 linux]$ git show 6aa56062eaba67adfb247cded244fd877329588d
>   fatal: bad object 6aa56062eaba67adfb247cded244fd877329588d
> 
> and so will everybody else. So from a documentation standpoint, you're
> actually adding negative information. Please don't.

My bad, I cherry-picked it from our public drm-intel-next tree and thought
it wise to include the cross-reference to explain the duplication and
merge conflicts and to provide some additional test history into the commit.
Obviously not enough information.

Is there a right approach here? I'm trying to be strict in that what is
sent upstream in -fixes are purely known regression fixes, and to preserve
test history on both -fixes and -next. That leads to situations like the
above where we have a commit that does not appear to relevant to stable at
first, but then is later shown to be required. How best to resolve the
eventual conflict that will show up in your tree? Just cherry-pick and be
dammed?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
