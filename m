Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625Ab2J2Uqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:46:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58828 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab2J2Uqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:46:42 -0400
Date: Tue, 30 Oct 2012 07:46:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20121030074631.9d148cb69a06a47d3dc78e65@canb.auug.org.au>
In-Reply-To: <20121029181534.GH4511@opensource.wolfsonmicro.com>
References: <20121029114848.cf0297e997cbfc9c2198fa5d@canb.auug.org.au>
	<20121029181534.GH4511@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Oct_2012_07_46_31_+1100_ChHy=jKORUBt+wUP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Oct_2012_07_46_31_+1100_ChHy=jKORUBt+wUP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, 29 Oct 2012 18:15:34 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> Honestly when I'm travelling with the automated build testing Fenguang
> and friends are doing it's actually faster to just push things up rather
> than doing testing of branches like this locally, their build farm
> usually kicks in very close to the time it takes me to do a single fresh
> build.

Then you need to have a different branch being tested by Fenguang and
friends to what you have in linux-next.   The stuff that you put into
linux-next has to be at least build tested, so you should delay pushing
it up to your linux-next included branch until after that is done.

This case was particularly irritating because you were the developer of
the patch that was broken which indicates that you are not even testing
your own development work before pushing it out for others to work on top
of.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__30_Oct_2012_07_46_31_+1100_ChHy=jKORUBt+wUP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQjusnAAoJEECxmPOUX5FEoNgQAJdb1lb/dcG4xm/5lecKNZ/j
QXQ9mNmuSbchuaO7K/Q3xJ5hjmVUiPjR0pdVS5gWzJtAji3J+Hu4+kkaX1t32wM0
7NjHRo7pHQT/plC69unmifdnCYK9Fmx+3XwbdmOK6J+/q5zQrfjAJ2DUH/l0/pSe
aDoUnNduCqsU1UDp9QsQDqFoVmY1+5LaC/7WvFNMRPh/TK43DgijjydCPTwyxj9u
qRSuQd01rB0P+dvusPlN4glX2+D/lAl9xF42UJO0YISYGsLZwiyMgsvDJgJa82Gc
FoBy2s7hupr0UnVUMI017wxgVH6AYTnZcLVYsMxLrLhghYamLVIxt4vxgFhM5PrX
3PqVsuZNEVB9djStxj9FuyaHQF5WswcSpEZw6FOBTPKoWQZOpCbA6OFFEAPHb5tv
FEAdzIXpFZwJmFzcx/HSdwuHhQD2LBu0czeMDkSV2XCSasG/w2nVDzau+3Y/ukUD
vVdCc6nqnHZfS68Mp3qrs0pxTLMPoquASjk1Z8YP/U8vj1RFTzpTkx2knDcK4MeL
tDTtGzRR2tI9cANAbzp+pNEBvej/Jv7pR1U6iYgZ8aWDeWaVGlPz0ip1ab7NBNDk
cFM9FqNrk37ZW3VcJwU2bi6Z4hI+IatIKhiM1tn5qFVags0ufaKPzRcyxsiA099N
SY1zya0+5fQZ/6A0MGgv
=JgEe
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Oct_2012_07_46_31_+1100_ChHy=jKORUBt+wUP--
