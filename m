Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0G0DcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 23:32:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35507 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab0G0DcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 23:32:18 -0400
Date: Tue, 27 Jul 2010 13:32:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: manual merge of the xen tree with Linus' tree
Message-Id: <20100727133207.9b6846fe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_13_32_07_+1000_c_.kCZYTL0WeILUD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_13_32_07_+1000_c_.kCZYTL0WeILUD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got a conflict in
arch/x86/kernel/hpet.c between commit
ff4878089e1eaeac79d57878ad4ea32910fb4037 ("x86: Do not try to disable
hpet if it hasn't been initialized before") from Linus' tree and commit
ef7612e63eafaa6101f5d3185ed8d9bf232ba627 ("x86: Do not try to disable
hpet if it hasn't been initialized before") from the xen tree.

Two versions of the same patch.  I used the version from Linus' tree
since it was dated later and had been modified by Thomas.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_13_32_07_+1000_c_.kCZYTL0WeILUD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTlM3AAoJEDMEi1NhKgbs+aIH/jo1JsOSvcVWhkOeYo+eMELG
e/HFMv0lgVuznfvHFzMXjyVTqVMhnGo8ShTqTMUUswpv1cYm+wrPkCRXJVjFNsZK
DYyygANuWIInkEUUlvc9jw71VIY8eA5HkOK+w9g1L1FPk+WZPY9FofGCdS9X4BAY
sHy02uWYUyMU4If7EtYICAosN8JfzgTuic88gh2whQQ0NLgsD8yHrQ+hN5CIu6dt
oizg+XNis4EmopXjvk+HoknZ3c+dGntJIVYrR5vD9FboUQ/pMpKavcLhwvAJr2oe
DFL30bRhYuF30ighP/4XR1gRIvGH5r9Opn1opoi7koLotwQh5vU0eYYcAdc0czo=
=8/el
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_13_32_07_+1000_c_.kCZYTL0WeILUD--
