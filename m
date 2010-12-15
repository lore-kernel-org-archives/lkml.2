Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0LOPEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:04:33 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56885 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826Ab0LOPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:04:30 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288566000"; 
   d="scan'208";a="83979966"
Date: Wed, 15 Dec 2010 16:04:26 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Microcai <microcai@fedoraproject.org>, "Ted Ts'o" <tytso@mit.edu>,
        Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101215150426.GA26989@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>, Microcai <microcai@fedoraproject.org>,
	Ted Ts'o <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org> <1290993244.877.3.camel@cai.gentoo> <20101129085829.GM5142@const.bordeaux.inria.fr> <1291023157.9785.2.camel@cai.gentoo> <20101129095823.GQ5142@const.bordeaux.inria.fr> <20101215144501.GB10467@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101215144501.GB10467@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Wed 15 Dec 2010 15:45:02 +0100, a écrit :
> > But complete unicode support (with arabic ligatures, tibetan
> > combinations, etc.) won't ever be accepted in the kernel as that's far
> > too involved in terms of font rendering.  So the userland way needs to
> > be fixed for these anyway, and then things like chinese will go along...
> 
> Well... english has ligatures, too (fi);

English ligatures are extremely far from what arabic needs. People
don't even actually know that there are ligatures in English, while for
arabic, people would even have a hard time reading something that isn't
using ligatures.

> console does not support them nicely and we still use it.

Err, I've very rarely seen the fi/ff ligatures on the console, it was
mostly from copy/pastes from pdf documents.

> Support for eastern european characters by default would be very very
> nice... and yes, that's just breaking the 256 char limit, nothing more
> complex.

The console can do 512 glyphs, not only 256, so eastern europe support
is a matter of combining a latin1 font with parts of the other latin
fonts. That already covers a lot of european languages.

Samuel
