Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1FGIbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:31:11 -0400
Received: from mailsrv1.zmi.at ([212.69.164.54]:39610 "EHLO mailsrv14.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1FGIbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:31:08 -0400
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: Drunkard Zhang <gongfan193@gmail.com>
Subject: Re: bug in xfs: can't recovery metadata log
Date: Tue, 7 Jun 2011 10:30:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.6-zmi; KDE/4.6.0; x86_64; ; )
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        linux-kernel@vger.kernel.org
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com> <201106070943.21004@zmi.at> <BANLkTikrmbe9X3Weyb8ikhn1RX_Tn_NuAg@mail.gmail.com>
In-Reply-To: <BANLkTikrmbe9X3Weyb8ikhn1RX_Tn_NuAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9287929.ziTybSKarZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201106071031.02928@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9287929.ziTybSKarZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. Juni 2011 Drunkard Zhang wrote:
> Oops, I already did "xfs_repair -L", successed. It's in production
> environment, didn't have too much time to figure out why :-(

That was probably the only chance anyway.

I'm wondering about the crash. Even if the log is full of shit because=20
of a crash, xfs should not drive to hell but better report the fact and=20
exit. But maybe such strict checking is not worth the effort, as every=20
competent admin does xfs_repair then anyway?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart9287929.ziTybSKarZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3t4cYACgkQzhSR9xwSCbSIygCffq+fnymmTsywcGoOx4vrrsdb
E/0AoN/q5gfyXV5IhdJjdFGhMQRkVhdy
=pbSI
-----END PGP SIGNATURE-----

--nextPart9287929.ziTybSKarZ--
