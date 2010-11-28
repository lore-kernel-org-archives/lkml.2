Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0K1Jut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 04:50:49 -0500
Received: from mail.perches.com ([173.55.12.10]:1908 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0K1Jur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 04:50:47 -0500
Subject: Re: [PATCH 4/4] zd1211rw: remove unnecessary [kv][mcz]alloc casts
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1290936606.3467.2.camel@jlt3.sipsolutions.net>
References: <cover.1290934782.git.joe@perches.com>
	 <704bdd89d630b364043ac7a9ec0a110d311a17a2.1290934782.git.joe@perches.com>
	 <1290935566.3467.0.camel@jlt3.sipsolutions.net>
	 <1290936047.16349.13.camel@Joe-Laptop>
	 <1290936606.3467.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 01:50:45 -0800
Message-ID: <1290937845.16349.16.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 10:30 +0100, Johannes Berg wrote:
> On Sun, 2010-11-28 at 01:20 -0800, Joe Perches wrote:
> > On Sun, 2010-11-28 at 10:12 +0100, Johannes Berg wrote:
> > > On Sun, 2010-11-28 at 01:05 -0800, Joe Perches wrote:
> > > > diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
> > > > @@ -117,8 +117,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
> > > >  	/* Allocate a single memory block for values and addresses. */
> > > >  	count16 = 2*count;
> > > > -	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> > > > -		                   GFP_KERNEL);
> > > > +	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)), GFP_KERNEL);
> > > I believe this is on purpose for sparse.
> > Perhaps in a previous version, but not now.
> How do you know? I thought sparse was pretty much not reliable after the
> first error it prints.

Good memory you have Johannes...

http://marc.info/?l=linux-netdev&m=117113743902549&w=3


