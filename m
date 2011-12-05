Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LEGMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:12:20 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39917 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1LEGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:12:19 -0500
Date: Mon, 5 Dec 2011 17:12:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please add my tree to linux-next
Message-Id: <20111205171207.3b3bc1ad6d99ad7d7c9c0792@canb.auug.org.au>
In-Reply-To: <4EDC594D.5040008@redhat.com>
References: <4ED8529E.5070608@redhat.com>
	<20111205100930.1bedc458a5e78b85c563465d@canb.auug.org.au>
	<4EDC594D.5040008@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Dec_2011_17_12_07_+1100_DTY43Ukl0qONS9No"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Dec_2011_17_12_07_+1100_DTY43Ukl0qONS9No
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
On Mon, 05 Dec 2011 13:40:29 +0800 Cong Wang <amwang@redhat.com> wrote:
>
> >       * submitted under GPL v2 (or later) and include the Contributor's
> > 	Signed-off-by,
>=20
> When I sent the patches out, they all have my Signed-off-by, but not in t=
he
> commit logs in my tree. Is this a problem?

Yes, you must have a signed-off-by line for each person who handles the
patches (in this case just you, since you are also the author).
Linus (in theory) would not merge your tree if you asked him to if it
lacked signed-off-by lines (and I will have to drop it if they are not
added - this will mean rebasing your tree, of course).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Dec_2011_17_12_07_+1100_DTY43Ukl0qONS9No
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3GC3AAoJEECxmPOUX5FEWQIP+gNqoQHg7YQu9txs4FaYLaxB
pgON4KUZ/z8pRFbrYEPLu1jSJrZs6gxDKwbGNEUHupkzZs9cFb3cAsW5Wn3eg7He
k2AkDjnUkKGxxkH8RvmdXdbmOqtCDqRd0oupXVMvYXYbDJPQxoM3G15g9r54NIRJ
3NQCALtLzva3hORKumz7lfvvmgQkMOBU4KUrPeSZqvzBu3+SLaXfLt2gPR11vsyq
9/zu9TK4HOyz5n9XkgSy1+REVPFDB10X/03g2foOfY7zBSXgiVQ4BdfFzCRKWqt+
l/P4tPJ1EOywYtYqQ3onD7QbTRgwYvnBfp+QL7dLRAHPZ1Yrfqt+GJcbWC8z/tuF
Ng5vuAuhvhZ1271AIhGr9WyaAtDHMbyVmyp6hgUakov6X78Al0fh7HQue/7PG6Af
lmHb6g88nBPedLif4QdoPTgE1/ycHeRrrLoWuChIMzx3eKx+P1CiIbCSlHBEsicL
/R1iZMvef6sPRCz23XQxgvYQtQE2tA2dssM83P1jykkO6h06/alJqpecHBofrfJG
ahjt4RTvHSuEsEg9SN4Lqxauh0WuhI6hXTW/ES/VBPt1LvHKTeZhmIVZyTgBy0vo
YmjXAgt70AujrBl1HuM7ZGno4zv3z0WKHkAFWCSqPmh46Vw70kcR0fFYJ5203+v9
XBnwIOua1wseLPo6Ngzp
=wLX9
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Dec_2011_17_12_07_+1100_DTY43Ukl0qONS9No--
