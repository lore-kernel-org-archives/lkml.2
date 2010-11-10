Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0KJCiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:38:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58825 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab0KJCiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RJLTTL4IGUCPq9oEYJPahuz20BjA+LJ4kCXFxw6pjIRfeUg6bbSjk3Aq2SE+kCcT2L
         ba6BNjsnKOtXiMVzeh+ezcYtOLcLHlWKoIU2a2KniJ85AEqTMXGNltlhNYnPnUcLIqvm
         gUuNGVlOBPFg6NDMf8B6JA1oCk79CjbGxIu5s=
Date: Tue, 9 Nov 2010 21:37:56 -0500
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101110023755.GB27340@roll>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com> <1287788622-25860-1-git-send-email-venki@google.com> <1288001573.15336.52.camel@twins> <1288097074.15336.211.camel@twins> <1288101958.15336.284.camel@twins> <1288381343.1988.12.camel@laptop> <20101109185516.GQ8332@bombadil.infradead.org> <1289329348.2191.69.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <1289329348.2191.69.camel@laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 09, 2010 at 08:02:28PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-09 at 13:55 -0500, Kyle McMartin wrote:
> > On Fri, Oct 29, 2010 at 09:42:23PM +0200, Peter Zijlstra wrote:
> > >=20
> > > not tested other than compile, but how does that look...?
> > >=20
> >=20
> > Hi Peter,
> >=20
> > I finally got around to building a test kernel for a user who had been
> > reporting this against F-14 (2.6.35) but they report there's not much
> > improvement.
> >=20
> > Sorry. :/
>=20
> Right, I tested it myself yesterday and got similar results. Does the
> 'simple' patch from a few posts back work for people?
>=20
>  http://lkml.org/lkml/2010/10/26/150
>=20
> If that does work I fudged the fancy math, if that doesn't work either
> we're back to square zero.

I seem to remember someone saying this would only work on x86-64; if this is
meant to work with a 32bit intel single core processor, please let me know -
I'd like to try it. It would also help if I knew which kernel version this
simpler patch is meant to apply to.

Thank you,
Tim McGrath

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTNoFg5EncCrqzVruAQISUgf+Ocl6ZGQEsJWtzDaWz0mbMMNOabJptFHf
SpvfNo0GApqrQFXCQVt+OLYqf6+390JPRWOLCVwhfwyxeK5I59tnPQ2XY+wafton
65rpxxExHPTEL7WEXJJvvK2IpDcdqNaYKRVhWb5r0NZ7tWCCusALYNAoTTQcIAuO
++ycfD9rlbkpkKWg6qPhnuwmcsHre47k880xpzmVz9+dzdW6Ej8WY6whoVDhLCQm
bwwHstjZrLtKMORc0EsOVB34MZT/t+vlaMpDF3PsTrH6CtkOwIvmYzLdpCm4cFLt
LWqm04biSImDlL5IfqQBOScrwjwDh6RbWp1hz2vMeLlmaCTTD69JbA==
=Busg
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
