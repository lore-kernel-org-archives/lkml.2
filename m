Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2ITVas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:30:48 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:44179 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab2ITVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:30:46 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v15)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com
In-Reply-To: <877grozaih.fsf@tucsk.pomaz.szeredi.hu>
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu> <9647.1348169684@jrobl> <877grozaih.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 21 Sep 2012 06:30:41 +0900
Message-ID: <32710.1348176641@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Aufs provides much better filesystem semantics than either unionmounts
> or overlayfs.  But that does come at a price:
>
> aufs:       98 files changed, 29893 insertions(+), 7 deletions(-)
> overlayfs:  22 files changed, 2981 insertions(+), 10 deletions(-)

Yes, I have to admit that aufs grew up very big.
The fundamental (by design) difference between them is considering how
important the filesystem semantics is. You may dislike a big module,
but I am interested in how you (or someone else) will implement the
missing overlayfs features to keep the semantics. One approach is
implemented in aufs. I guess you will try another one. That is what I am
interesed.


J. R. Okajima
