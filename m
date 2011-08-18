Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1HROT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:19:27 -0400
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:46408 "EHLO
	mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1HROT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:19:26 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes with linux-3.1-rc2
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan> <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
Date: Thu, 18 Aug 2011 23:19:21 +0900
Message-ID: <9214.1313677161@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Justin Piszcz:
> > It has not crashed yet (which is good), I'll apply this patch to my
> > production machine and test taking backups of this data and let you know
> > if it crashes again, thanks!
	:::
> It is working but very slowly:

As you might know, the patch is totally unrelated to the performance. It
just fixes a memory corruption at unmounting or when an error in mounting.


> you have to transfer 5-10TB.  However, it is not crashing anymore, so any 
> speed is better than that :)

But you are not satisifed obviously. :-)


J. R. Okajima
