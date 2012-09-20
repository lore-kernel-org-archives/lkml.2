Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2ITUqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:46:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54448 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2ITUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:46:35 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v15)
In-Reply-To: <9647.1348169684@jrobl> (J. R. Okajima's message of "Fri, 21 Sep
	2012 04:34:44 +0900")
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
	<9647.1348169684@jrobl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 20 Sep 2012 22:48:06 +0200
Message-ID: <877grozaih.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

> Miklos, how do you think about this?
> <http://marc.info/?l=linux-kernel&m=123938533724484&w=2>
> Do you think UnionMount is totally gone?

Unionmount provides almost the same functionality as overlayfs.  The big
difference between the two is that unionmounts resides 100% in the VFS
while 95% of overlayfs is plain filesystem code.  I think that's the
biggest advantage: filesystem code is easier to maintain, has less
impact on core complexity, etc.

Aufs provides much better filesystem semantics than either unionmounts
or overlayfs.  But that does come at a price:

aufs:       98 files changed, 29893 insertions(+), 7 deletions(-)
overlayfs:  22 files changed, 2981 insertions(+), 10 deletions(-)

Thanks,
Miklos
