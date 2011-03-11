Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1CKBTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:19:07 -0500
Received: from ozlabs.org ([203.10.76.45]:47443 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1CKBTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:19:05 -0500
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110311003846.GA23548@linux-mips.org>
References: <4D790A13.4060705@caviumnetworks.com>
	 <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
	 <1299782143.15854.402.camel@gandalf.stny.rr.com>
	 <4D791CAA.7090108@caviumnetworks.com>
	 <1299783236.15854.405.camel@gandalf.stny.rr.com>
	 <4D791F31.6040100@caviumnetworks.com>
	 <1299785143.15854.407.camel@gandalf.stny.rr.com>
	 <1299786329.15854.409.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP39EE03AE86CF0F0E5C570596C80@phx.gbl>
	 <20110311003846.GA23548@linux-mips.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y+dSBof8YrcFC+qDI/Yz"
Date: Fri, 11 Mar 2011 12:19:05 +1100
Message-ID: <1299806345.22649.42.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y+dSBof8YrcFC+qDI/Yz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-03-11 at 01:38 +0100, Ralf Baechle wrote:
> On Thu, Mar 10, 2011 at 04:22:14PM -0500, Mathieu Desnoyers wrote:
>=20
> > You seem to be contradicting yourself here. I'm concerned about having
> > "structures" of a size not power of two. Can we simply either
> >=20
> > - Add a padding element at the end
> > or
> > - use .align 4*sizeof(long) at the beginning
> >=20
> > to make sure the linker won't put any holes when it puts objects=20
> > together ?
>=20
> It may only be a technicality but but careful with .align.  On some
> architectures .align x will align to a multiple of x; on other
> architectures to 2^x.  Another reason to stick to C wherever possible.

.balign is saner:

http://sourceware.org/binutils/docs-2.21/as/Balign.html

cheers

--=-Y+dSBof8YrcFC+qDI/Yz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk15eIkACgkQdSjSd0sB4dLTiQCeJ9HhrFiefYhEiNgmbryJOs65
0q4AnjgTz9unvhfwJvZLcCd+dwze7Vh1
=DFL5
-----END PGP SIGNATURE-----

--=-Y+dSBof8YrcFC+qDI/Yz--

