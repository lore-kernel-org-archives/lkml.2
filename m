Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab1FPXlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 19:41:13 -0400
Received: from mail07-md.ns.itscom.net ([175.177.155.117]:57172 "EHLO
	mail07-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab1FPXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 19:41:12 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>, "neilb@suse.de" <neilb@suse.de>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
In-Reply-To: <BF42D8D9-B947-448A-8818-BCA786E75325@fsl.cs.sunysb.edu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu> <b624059d70d546d4a4ecb940613235ab@HUBCAS2.cs.stonybrook.edu> <BF42D8D9-B947-448A-8818-BCA786E75325@fsl.cs.sunysb.edu>
Date: Fri, 17 Jun 2011 08:41:03 +0900
Message-ID: <15841.1308267663@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> My point is that Overlayfs has ENOUGH useful features NOW to be merged. =
> What stops it from going in?! More freeping creaturisms? Why do we need =
	:::

As I wrote before, I have no objection about merging overlayfs or
UnionMount. My point is they have unioning feature but don't have some
of essential filesystem features. I don't think it is a trade-off or
something.
As you and other people wrote, many years passed in unioning. The very
basic features are already achieved in very early stage. The point is
how normal filesystem features are designed and implemented.
I am discussing about the design and feature of unioning, but don't stop
merging overlayfs.


> We cannot ask Overlayfs to support all of the features that other =
> solutions have, b/c it may take a very long time to get those in when =

Agreed, particularly union-specifc extra features.
Actually I am not asking overlayfs to support all features aufs has. You
may think what I am doing as a design review.


> The vast majority of unioning users want 2 layers, one readonly, one =
> read-write. Those who really want 3+ layers can use stack Overlayfs =
> multiple times: yes it'd be less efficient, but so what? First we want =

I don't think consuming stack space is efficiency issue.


> We all have to accept a solution that's pretty good NOW but less than =
> perfect.  Otherwise we'll continue to have these debates and discussions =
> for years on end.

If you think merging overlayfs means the end of discussion, then I won't
agree. It may be a beginning.


J. R. Okajima
