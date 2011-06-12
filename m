Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1FLHpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 03:45:03 -0400
Received: from mail08-md.ns.itscom.net ([175.177.155.118]:48696 "EHLO
	mail08-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1FLHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 03:45:00 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
In-Reply-To: <BANLkTi=Vu4t+FFKGapJZVjQ_e1rGD7ug2g@mail.gmail.com>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu> <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl> <BANLkTi=Vu4t+FFKGapJZVjQ_e1rGD7ug2g@mail.gmail.com>
Date: Sun, 12 Jun 2011 16:44:53 +0900
Message-ID: <15119.1307864693@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Suchanek:
> Anyway, as I understand it aufs is not going to be merged because the
> VFS maintainers don't want a filesyetem (like aufs) but do accept only
> mount (overlayfs or unionmount).
>
> So overlayfs is the only way forward now since unionmount development
> has stopped.

Actually overlayfs is union-type-filesystem as aufs, instead of
union-type-mount.
If the development of UnionMount is really stopped, then I'd ask people
to consider merging aufs as well as overlayfs.


J. R. Okajima
