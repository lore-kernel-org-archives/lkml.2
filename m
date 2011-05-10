Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1EJDF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:05:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45680 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab1EJDF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:05:56 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110505225302.GC12316@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
	 <1303263653.3464.65.camel@localhost> <20110420020128.GA27631@suse.de>
	 <1303265862.3464.77.camel@localhost> <20110420031105.GA11945@suse.de>
	 <1303274910.3464.95.camel@localhost> <20110420050617.GA16756@suse.de>
	 <1303356555.3464.128.camel@localhost>  <20110505225302.GC12316@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-SAqdWA4r70Q9QZWwOtmM"
Date: Tue, 10 May 2011 04:05:49 +0100
Message-ID: <1304996749.4065.176.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SAqdWA4r70Q9QZWwOtmM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-05-05 at 15:53 -0700, Greg KH wrote:
> On Thu, Apr 21, 2011 at 04:29:15AM +0100, Ben Hutchings wrote:
[...]
> > 2.6.32.29: 'USB: Prevent buggy hubs from crashing the USB stack' broke
> > MUSB on BeagleBoards (still unfixed?)
>=20
> This woried me, as I don't recall anyone notifying me of it.  Then I saw
> your revert, and I noticed that all you really need to resolve this is
> commit id ec95d35a6bd0047f05fe8a21e6c52f8bb418da55 to be added to the
> tree.  I'll go queue that one up for the next .32-stable tree.
>=20
> So all should be resolved now, right?

Yes, thanks.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-SAqdWA4r70Q9QZWwOtmM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATcirh+e/yOyVhhEJAQoGQQ/+MQ4F42llSNHcNzmM9ZSnzTEB72shpj3c
z8C56rOdjFuThS+Zq+nswNoEN4WN14omhdHpu5AWhXgg1SuYDs91PgLh3EiPNqe/
e/iBIZBHciZU1eQ8zjiw3oSf5nkiyy+xwep8W2naPcX09Y7dZbmBBFbhjWphJL9v
VL6k8oedx5Bhq5DJpXyjflA2KZw34g5lV46ztw0LrWDKIix7CuXeHuaHmYvscrGR
QmDZMJuFH7wvlnAKSHqh3l1l1ky7lvqVtD+EUJslVZd8GabEWIsDsHogFQ51rFhR
mdor074Z8wDR58GloymN98LroyIDTeTjZbTcrDAbEiQoXI/s5ylETtuqbzZdag6F
9nXv++4j9sA8IzrnkOWSo9cuKrM56gneBJ9ZiD9F2p7ol84XsHV9uFvM61Tmr9lY
Xun/20VzAtw7vA5xM17XmSbHSbsWiMXBOuq32f7WnDeNZy+s/y9SIpbD2bcvwM5Y
FDl7x8YV8GnoHW/NDICSImlsTYwQspbxAbeOyeQ6b3ndDdhaj1x6v6oy2gVoQtrN
s1ZfpUYmK0P46CvDhRYgH4O1fjGMJ+NMbAiKRDGrnwWBRg89uiazO0fvHWaR554W
p5KW6rFBqWAMfDJu6GOTTQRToTzW8C4YczYIQxCZhBmLsfvEIB0O2uud6eLmektu
/HamSPgh3JQ=
=sD4G
-----END PGP SIGNATURE-----

--=-SAqdWA4r70Q9QZWwOtmM--
