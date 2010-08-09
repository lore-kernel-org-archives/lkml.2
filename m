Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0HIWg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:36:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:55236 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab0HIWgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:36:19 -0400
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vadim Zaliva <lord@crocodile.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201008090933.32446.dmitry.torokhov@gmail.com>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
	 <9D74DA20-E3C8-43BC-B529-82605F64637F@crocodile.org>
	 <1281325390.2168.64.camel@pasglop>
	 <201008090933.32446.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 08:36:02 +1000
Message-ID: <1281393362.2168.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 09:33 -0700, Dmitry Torokhov wrote:
> 
> > I'd rather roll the patch back for now. I'll send the revert as part of
> > the next powerpc update. We'll sort things out then.
> 
> I'll be sending pull request to Linus this evening and should take care of
> this as well. I guess we need to pull it out of stable as well since Vadim's
> thouchpad was usable even with older code but some touchpads are completely
> broken now.

Right.

> We can re-instate the fix later when we make sure it works fr everyone.

Yup. BTW. The pull request I sent to Linus yesterday has a revert for
that. Can you take care of stable ?

Thanks !

Cheers,
Ben.

