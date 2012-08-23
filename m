Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab2HWAEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:04:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47953 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755697Ab2HWAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:04:47 -0400
Message-ID: <1345680284.15245.16.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 43/46] KVM: x86 emulator: fix byte-sized MOVZX/MOVSX
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>
Date: Thu, 23 Aug 2012 01:04:44 +0100
In-Reply-To: <20120820035838.239345023@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
	 <20120820035838.239345023@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4MseRAGDIzCuhoe0PDLB"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4MseRAGDIzCuhoe0PDLB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 20:59 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Avi Kivity <avi@redhat.com>
>=20
> (cherry picked from commit 361cad2b50a2c92b91b6f568db860fabad3bf149)
>=20
> Commit 2adb5ad9fe1 removed ByteOp from MOVZX/MOVSX, replacing them by
> SrcMem8, but neglected to fix the dependency in the emulation code
> on ByteOp.  This caused the instruction not to have any effect in
> some circumstances.
>=20
> Fix by replacing the check for ByteOp with the equivalent src.op_bytes =
=3D=3D 1.
[...]

Also needed for 3.4, based on the commit that's blamed.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-4MseRAGDIzCuhoe0PDLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDVznOe/yOyVhhEJAQrJmw//dNejiAKsQilXYaQ3xx3Z+zMXoOG5DuUF
W47Km1BN0Rv4dlLgh5EUljSG/TcOm3g9qcwguN/Mt7DYY6PUz3yZUGpRtgtCkIu+
V1oNJqpcAeDp1UVIYNggD6EdFCYN8KHKW9kYGkEGPtmppU8r09bUsG6SBg6EuDXJ
rXgHphFwLETUn9xKDq18dNwYov385rbCMrHPoGjNVXc/HaKgFhefIZGC6d3kXQvT
3sWTW3af9Tcbu0NwBYou27VQ6CjQTfuF2USMMUd+v0fV+XYsW0oKfmAR4zqKzi1F
Oxad6z8mB5IGICJFJAWC15pmkik/ZX24lMyEyJoQUOs/rs2nLoaGPzwU2fLfAvA4
w6mT68j3Vjo7wwX7GFJTsV1ehyJHndiGVMMEgsKgVScYNg1Oeto3xJ12ZQYntUMx
3eFFrjIWmgaG05M3ezSgQg1qSBFAljc5u1etBYdaGaPY4d4mUeCg+Q2E4eE+lzNn
kHT4FZDVR+OvlC5rrbOrSpA56Stzucp6txWDiuTSOVv1ylLLzzmPWJqz78ieJeIn
oBQrB+OR21yOzxqz/ezLpHrxG6wQuSrVLIXxGBcB2zJ7bNqVEWXyeMnuw+KlCAzT
LNNxzpRoccjnQ2XFBoL8rPBPjEl9Bk4bBfMkOi0yoZxZhTZ5WkeOnHDn5CLaxowK
VGhyBWHyxhA=
=+Wlb
-----END PGP SIGNATURE-----

--=-4MseRAGDIzCuhoe0PDLB--
