Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1FQBt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:49:29 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:33092 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab1FQBt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:49:27 -0400
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
In-Reply-To: <BF19F4F8-9E0F-4983-87C1-BB1B0A11D011@fsl.cs.sunysb.edu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu> <b624059d70d546d4a4ecb940613235ab@HUBCAS2.cs.stonybrook.edu> <BF42D8D9-B947-448A-8818-BCA786E75325@fsl.cs.sunysb.edu> <ab75a25c918145569b721dea9aea5506@HUBCAS2.cs.stonybrook.edu> <BF19F4F8-9E0F-4983-87C1-BB1B0A11D011@fsl.cs.sunysb.edu>
Date: Fri, 17 Jun 2011 10:49:20 +0900
Message-ID: <16748.1308275360@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> OK. Then I believe you and I are in agreement:
>
> - Overlayfs has useful features to be merged now; no objections here.
> - Other features can be added later on.

Yes, that is what I wrote.


> If, however, you feel that Overlayfs has some fundamental design flaws =
> that prevent important future features from being added easily after a =
> merge, then please outline such design flaws.

I have made some suggestions and pointed out several issues actually.
If my English is enough poor to make you misunderstood, then please
point out with quoting.

But Erez, don't you remember that you requested me to promise not to
submit aufs for inclusion into mainline until unionfs gets accepted and
I agreed? Do you really think I am bothering overlayfs?

Here is a suggestion about your patch for ovl_show_options().
It is better to call d_path() or something instead of copying and
holding the paths, since overlayfs already has mnt and dentry. And with
d_path(), show_options will be able to follow even if the upper/lower
mount is moved.


J. R. Okajima
