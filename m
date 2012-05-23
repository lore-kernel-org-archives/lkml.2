Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674Ab2EWRds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:33:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48530 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760641Ab2EWRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:33:46 -0400
Date: Wed, 23 May 2012 18:33:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
Message-ID: <20120523173342.GB4064@opensource.wolfsonmicro.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au>
 <4FBBAF1B.1070702@xenotime.net>
 <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
 <20120523093208.GB4085@opensource.wolfsonmicro.com>
 <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 08:51:39AM -0700, Linus Torvalds wrote:

> Multi-level pure selects *should* work correctly. So you can select
> stuff that then in turn selects other stuff - and that should all be
> fine.

They're supposed to, and mostly do, but there's been some fragility
there.  That said there's not been anything recently, perhaps I just got
hit with fallout from some development that was going on.

> It's *dependencies* that do not work.

Right, and nor are they supposed to since it's not clear what they
should do.  That's a completely different thing.

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvR9wAAoJEBus8iNuMP3dWVQP/RLgGMtPppEDLepvinaCXQwx
UXNbSYxoraz7wEH8+nbJkBy9zT5TwG2lhBoctzu6tjSvGwQ1jhEJWDnu1dPL1xHL
tSkAC1laf/sWcznmEoSeIrLud20TaMnWy47QxAomY028uwvqg1YA74h4dwDr6jGd
J6tZLRIvYNtUuYGzJPmcXGFmkVkXcg+6O971v7EKUfz+kj4+ptoPVFW2354aulyu
2yZstWvw0RQWkVxGCj4933BIR8CPHXb4xRT2ZK0LhVimBaAgXcxYhBiqMwpP1KaF
VxKCNtyZipXyKVKWUkxcODdVCGEKF0Eq+z2NksNZd0jhftquuXppfqXammbnWNmh
3aNWB+DDRaNtrdU2QUOLGQOPPmumsoBbKsZ5s2gECxyrt1cV4sG7ekQlf2jUb4zj
jS19PiBa6n3LG+AdwCgl3gIrkAQmpcWGWJjIWh61HgKPN3DMwU7zOiYNXC+y8TQW
nE4h9ouvmL7ZiFXt6KRg/bRfLHK+EB4ylveztYhQFivlFDs0ibb9vicUq4MX/5rv
2iK9+pbY68b9WZsFeWH4F4cZOLbEmZLxMQrZ/NPt5lMVQRThwtvJGOLiMi/B3hsu
7qok2pQ69P3Ed6rkowse8JRkQNQ3b7VFYJU0LVOBAWp2AHYOiSpPEM1yrIX46LX2
XzQMCwHTQkqFvRZ0fVjj
=L3MC
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
