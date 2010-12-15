Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0LOOpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:45:14 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57317 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752158Ab0LOOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:45:12 -0500
Date: Wed, 15 Dec 2010 15:45:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Microcai <microcai@fedoraproject.org>, "Ted Ts'o" <tytso@mit.edu>,
        Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101215144501.GB10467@ucw.cz>
References: <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
 <1290951770.13526.18.camel@cai.gentoo>
 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
 <20101129020610.7ea7c79e.lisa@ltmnet.com>
 <1290961207.13526.31.camel@cai.gentoo>
 <20101128194624.GP2767@thunk.org>
 <1290993244.877.3.camel@cai.gentoo>
 <20101129085829.GM5142@const.bordeaux.inria.fr>
 <1291023157.9785.2.camel@cai.gentoo>
 <20101129095823.GQ5142@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129095823.GQ5142@const.bordeaux.inria.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I have many different kinds of patchs that did it in different ways.
> > 
> > What realy matters is that, do we agree that add unicode font support is
> > acceptable ?
> 
> Simple unicode font (i.e. just go beyond the arbitrary historical-vga
> 512 glyphs limit for fbcon) might go in.  Double-width is questionable,

That would be very nice, yes.

> But complete unicode support (with arabic ligatures, tibetan
> combinations, etc.) won't ever be accepted in the kernel as that's far
> too involved in terms of font rendering.  So the userland way needs to
> be fixed for these anyway, and then things like chinese will go along...

Well... english has ligatures, too (fi); console does not support them
nicely and we still use it. Support for eastern european characters by
default would be very very nice... and yes, that's just breaking the
256 char limit, nothing more complex.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
