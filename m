Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2ITTeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:34:50 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:42339 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2ITTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:34:49 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v15)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
In-Reply-To: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
Date: Fri, 21 Sep 2012 04:34:44 +0900
Message-ID: <9647.1348169684@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for CC-ing me.

Miklos Szeredi:
> Please consider overlayfs for inclusion into 3.7.
>
> It's used by Ubuntu and by various other projects.  I regularly get emails
> asking when it will be included in mainline.

AUFS is in very same situation for years.
Miklos, how do you think about this?
<http://marc.info/?l=linux-kernel&m=123938533724484&w=2>
Do you think UnionMount is totally gone?


> Git tree is here:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v15

Years ago, I also switched the AUFS development base (and releases) to
GIT on SourceForge due to the request from Ubuntu people.


J. R. Okajima
