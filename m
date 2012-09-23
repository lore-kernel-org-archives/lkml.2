Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2IWNCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 09:02:33 -0400
Received: from ares07.inai.de ([5.9.24.206]:46406 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab2IWNCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 09:02:31 -0400
Date: Sun, 23 Sep 2012 15:02:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        dhowells@redhat.com, sedat.dilek@googlemail.com
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v15)
In-Reply-To: <877grozaih.fsf@tucsk.pomaz.szeredi.hu>
Message-ID: <alpine.LNX.2.01.1209231500400.15692@nerf07.vanv.qr>
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu> <9647.1348169684@jrobl> <877grozaih.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-09-20 22:48, Miklos Szeredi wrote:
>
>> Miklos, how do you think about this?
>> <http://marc.info/?l=linux-kernel&m=123938533724484&w=2>
>> Do you think UnionMount is totally gone?
>
>Unionmount provides almost the same functionality as overlayfs.  The big
>difference between the two is that unionmounts resides 100% in the VFS
>while 95% of overlayfs is plain filesystem code.  I think that's the
>biggest advantage: filesystem code is easier to maintain, has less
>impact on core complexity, etc.

The big advantage is actually that the unioned view is in a separate
namespace (vfsmount).

>Aufs provides much better filesystem semantics than either unionmounts
>or overlayfs.  But that does come at a price:
>
>aufs:       98 files changed, 29893 insertions(+), 7 deletions(-)
>overlayfs:  22 files changed, 2981 insertions(+), 10 deletions(-)

In two years time when sufficient user requests have come in,
overlayfs is likely to have wrong as much.
