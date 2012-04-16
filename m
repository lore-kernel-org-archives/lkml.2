Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2DPQ1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:27:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2DPQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:27:15 -0400
Date: Mon, 16 Apr 2012 09:27:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
Message-ID: <20120416162710.GA24100@kroah.com>
References: <20120412011313.GA23764@kroah.com>
 <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
 <20120412144626.GA14868@kroah.com>
 <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
 <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
 <20120413105746.10ffb120@stein>
 <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
 <20120413190819.9469.qmail@stuge.se>
 <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one minor correction in this looney email thread:

On Sat, Apr 14, 2012 at 01:53:22AM +0300, Felipe Contreras wrote:
> v3.3.x on the other hand are *not* stable. They contain patches
> backported from v3.4, but nobody guarantees they will work. There was
> no v3.3.1-rc1, so the first time the patches compromising v3.3.1 were
> generally tested together is in v3.3.1, at which point if somebody
> finds issues, it's too late; bad patches are *not* going to be removed
> in v3.3.2.

Of course there was a 3.3.1-rc1, see the linux-kernel archives for the
announcemen and the individual patches.  kernel.org has the large patch
itself if you like that format instead.

greg k-h
