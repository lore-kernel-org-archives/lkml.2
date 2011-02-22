Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1BVWXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:23:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37623 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab1BVWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:44 -0500
Date: Wed, 23 Feb 2011 09:22:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mattia Dongili <malattia@linux.it>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
Message-Id: <20110223092237.d3d183c3.sfr@canb.auug.org.au>
In-Reply-To: <20110222143434.GA9720@srcf.ucam.org>
References: <20110222162206.c3fb0636.sfr@canb.auug.org.au>
	<a8c6f32c-ccb5-4f65-b537-8bd1c11f7336@email.android.com>
	<20110222114601.GA936@kamineko.org>
	<20110222143434.GA9720@srcf.ucam.org>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Feb_2011_09_22_37_+1100_EYthjVzx.opmGaP8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Feb_2011_09_22_37_+1100_EYthjVzx.opmGaP8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Feb 2011 14:34:34 +0000 Matthew Garrett <mjg59@srcf.ucam.org> wr=
ote:
>
> On Tue, Feb 22, 2011 at 08:46:01PM +0900, Mattia Dongili wrote:
>=20
> > how does linux-next work? should this patch be a separate commit or can
> > it be folded into the offending one?
>=20
> I'll fold it into the offending one and repush. Sorry about the=20
> breakage, Stephen - I don't have DEBUG_ALLOC enabled so didn't see the=20
> failure. Do you build with a defined configuration I can test against?

As the original report said, this was an x86_64 allmodconfig build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Feb_2011_09_22_37_+1100_EYthjVzx.opmGaP8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNZDctAAoJEDMEi1NhKgbschgIAJJH3vAIr3/jlbh6qEwEE1da
4FC+st5xXcPmGZB+w9mbZAQ6CSBK34jmmL3F7okeSzd5JOnBElTQaWLJ8/eDhzB6
bWYHXnQmLoDdG1/XW3rbp7yzK5/IJ2BNANDHdt8CKHWZBxnggbfqwlYZ01dOugRp
VlHkptugbnh3H5xkHuui76eafHX+SIFTPyK2s4VmvzYs0EVzKNIL9ptVxSt7IzZd
+/C+93x75jvpyVw2lpFNkHCL/Oun0pnFBbzcRh3Nl+pteC0WbvF0sMOs1HBIyKuK
Fz2ne69Lgk6GgmU+6cVEvfR7FjzSg5tof3H66Helps3eFdKwkVoz+wglX+8mbHg=
=XIV+
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Feb_2011_09_22_37_+1100_EYthjVzx.opmGaP8--
