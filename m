Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0LHCM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:12:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111Ab0LHCMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:12:25 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
        avi@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20101208004428.893591835@clark.site>
References: <20101208004428.893591835@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZXk3QBwFeXw9bog4QTsz"
Date: Wed, 08 Dec 2010 02:12:17 +0000
Message-ID: <1291774337.25629.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [046/127] KVM: VMX: Fix host userspace gsbase
 corruption
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZXk3QBwFeXw9bog4QTsz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-12-07 at 16:43 -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Ben Hutchings <ben@decadent.org.uk>

This should be credited primarily to Avi.

Ben.

> commit c8770e7ba63bb5dd8fe5f9d251275a8fa717fb78 upstream.
>=20
> We now use load_gs_index() to load gs safely; unfortunately this also
> changes MSR_KERNEL_GS_BASE, which we managed separately.  This resulted
> in confusion and breakage running 32-bit host userspace on a 64-bit kerne=
l.
>=20
> Fix by
> - saving guest MSR_KERNEL_GS_BASE before we we reload the host's gs
> - doing the host save/load unconditionally, instead of only when in guest
>   long mode
>=20
> Things can be cleaned up further, but this is the minmal fix for now.
>=20
> Signed-off-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> [bwh: Backport to 2.6.32]
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[...]

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-ZXk3QBwFeXw9bog4QTsz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATP7peOe/yOyVhhEJAQK0jhAA1bJnaPlQ7ejepye2+mEnIL/pAqvKHxij
x3o0JVNlp22etr5PDKvb1zdgVI60e0tmA9Dgr4J7LT0/6c438wHCm5h2TDuBw22B
rh+37O4gHNHN9wmQiyxQFV/8rgny7577jcpOeWJTqzft+9WoLa45WPmrtlkuA2pB
5ao7XtYmaI8QYIrx6wRPHx3MdQGvpW6IfzQg8wWKpQCKucGjgiUgC8S89Ggd75fL
ovMQ2fHliEalpV/L0zXu+0l7Nbo+2Wr7tdQONIWeZHm5SSCWHSun8y0G6AWTbby7
HCg+Ce7yEvbi+y5cj583Zda+H+hnHn1m2jzvQpTZLoy+YXiA0dg2iJ6wcmlAnzwc
S7ol57qocBXTho/ykHTnq7TdO6gnTPWZzknaNxMeEAwBqmlSjOfkcj0Hzk+7w3TD
eKxnzvkaIxA9YQ7iqvV9UEsWWIy9iAHMwBSzaIUPuKcb8+v6u/tGCz+YK9/qThbl
4gNSIkCKl+EGCejIg/WatO5MyrfaAcEt3WqUtWPzpGfPKyNv1p2Ixs/nGJAI/cjN
Ws39VZRYC8uKxdj8RN8Ko4jD7gut99LRuGcIObBwWt3kmXPYF8uVq8OCaoCb3l+5
c4Di6QCtOHIMAzAegTT9i6DzxUlzZQMkE8TJvS1W1J4kiFo8waiaDwoelqHi46Kb
Trxu8AW4Ovw=
=Q/f4
-----END PGP SIGNATURE-----

--=-ZXk3QBwFeXw9bog4QTsz--
