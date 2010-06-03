Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab0FCDpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:45:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933730Ab0FCDo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:44:59 -0400
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
	 <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
	 <87d3w9582z.fsf@deeprootsystems.com>
	 <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O4IKJdT/4tWhdteoYnrL"
Date: Thu, 03 Jun 2010 13:44:58 +1000
Message-ID: <1275536698.22020.81.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O4IKJdT/4tWhdteoYnrL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-06-02 at 18:20 -0700, Linus Torvalds wrote:
>=20
> Now, I'm actually considering just getting rid of all the 'defconfig'=20
> files entirely. The x86 model is sane (there's two of them, nobody likely=
=20
> uses them), but ARM and POWERPC (and to a lesser config SH and MIPS) have=
=20
> turned the whole concept into a disgusting mess.=20

I agree that the defconfig mechanism is broken (ie. carrying the full
text in tree), but the concept is sane IMHO.

What'd be nice is if the defconfig could just be a delta against a base
config for the architecture - that would make most of them reasonably
small, just turning on/off a few options.

You can sort of do that today, by just storing a delta, but oldconfig
will silently turn off things you have enabled if prereqs change, so
that doesn't really work I think.

cheers

--=-O4IKJdT/4tWhdteoYnrL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwHJToACgkQdSjSd0sB4dJ43ACfUZ6V24e2Zs3+sxj2iPnsn2Nt
B70AnA3JzwKGp4hHYBfyNKUb2AYRaxa5
=ERO9
-----END PGP SIGNATURE-----

--=-O4IKJdT/4tWhdteoYnrL--

