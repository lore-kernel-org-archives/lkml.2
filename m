Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1AMKm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:42:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42468 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab1AMKm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:42:56 -0500
Date: Thu, 13 Jan 2011 21:42:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: clearcache (Was: Re: [git pull] vfs pile 1)
Message-Id: <20110113214239.1b23b523.sfr@canb.auug.org.au>
In-Reply-To: <20110113085547.GA7414@infradead.org>
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
	<20110113172557.c016ec51.sfr@canb.auug.org.au>
	<20110113085547.GA7414@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Jan_2011_21_42_39_+1100_zm0reTM_EycFAd8I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Jan_2011_21_42_39_+1100_zm0reTM_EycFAd8I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Thu, 13 Jan 2011 03:55:47 -0500 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> How did cleancache end up in linux-next again?

Um, I asked after the last merge window (on November 17, cc'ing you, Al
and Linus) and the only reply I got was from Dan saying that he was
hoping to work more on it with some chance of being ready for 2.6.38 ...

So, let me ask again:

"I didn't really follow the discussion at Kernel Summit, but there seemed
to be some question as to whether the cleancache stuff will be merged or
not.  It missed 2.6.37 (obviously), but my question now is do I keep in
in linux-next in the hope that it will be merged in 2.6.38?  Or is that
not going to happen?"

(The cleancache tree has not changed since October 9 last year.)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Jan_2011_21_42_39_+1100_zm0reTM_EycFAd8I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNLtcfAAoJEDMEi1NhKgbsCvYH/3vnF5d5PVq125QOEfcmeRuB
fYBc+fvDw4TcQKtfLg8qjnixhlESJHiMhEjFrebkkmdKOlAD9dzj8S/CXLmhEhJ2
YGv1i6twQcFZkB3yxb2WEN+NW2KDJRM5cZE1IrAHr8ONjHV0lQW2U0Oa6zSH8tdW
yJL3Ex/RGFmVmMI1oEQ8tcN6S15PpRoysJOrefHxJgNUM6ZWOZos+H9nTz08YoUX
y3CCOgn+oVuV8yDD8hcboH2u97/P1gDUv226j4OrDz+KG1t/9qWHwo4iFxcGUoH4
PPLUtWIrGvT2CbkQbyZebRI0bJq9ponEpSjqF8bbVH7Xb46hp0QC05sSAlg2FaM=
=xzaW
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Jan_2011_21_42_39_+1100_zm0reTM_EycFAd8I--
