Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1ANQl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:41:27 -0500
Received: from www.tglx.de ([62.245.132.106]:59628 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab1ANQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:41:19 -0500
Date: Fri, 14 Jan 2011 17:40:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <npiggin@gmail.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
In-Reply-To: <AANLkTinAseKuc3=JxB2qZGz2D4KUyjj=dbnoKfSyVLqh@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101141740120.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6> <8952.1294927845@jrobl> <alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6> <AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com> <alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
 <AANLkTinAseKuc3=JxB2qZGz2D4KUyjj=dbnoKfSyVLqh@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Linus Torvalds wrote:

> On Fri, Jan 14, 2011 at 1:29 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Can you point us to the patches, so we can run our own set of
> > tests in paralell?
> 
> They should be in current -git as of yesterday evening.
> 
> In particular, I think this one is commit 90dbb77ba48d.

Yep, that works - though it needs the pending fixes from Nick latest
pull request as well

Thanks,

	tglx
