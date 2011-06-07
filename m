Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1FGHx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:53:59 -0400
Received: from mailsrv1.zmi.at ([212.69.164.54]:54132 "EHLO mailsrv14.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1FGHx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:53:56 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 03:53:56 EDT
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: xfs@oss.sgi.com
Subject: Re: bug in xfs: can't recovery metadata log
Date: Tue, 7 Jun 2011 09:43:18 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.6-zmi; KDE/4.6.0; x86_64; ; )
Cc: Drunkard Zhang <gongfan193@gmail.com>, Alex Elder <aelder@sgi.com>,
        xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com> <BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com>
In-Reply-To: <BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1653724.kM9ukQj4WN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201106070943.21004@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1653724.kM9ukQj4WN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. Juni 2011 Drunkard Zhang wrote:
> With 2.6.39.1 too, output not the same thing.

I'm not a developer, but have you tries xfs_repair -n ? As you crashed,=20
probably the xfs log is damaged, needing a "xfs_repair -L", but wait for=20
a more competent answer before you do this.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1653724.kM9ukQj4WN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3t1pgACgkQzhSR9xwSCbR3LQCggGekCvYKvSgMEnA7QXCP5bm7
q1QAoOOrZUa70PS2oeE7ZRTxGG9z4LIu
=Tkyj
-----END PGP SIGNATURE-----

--nextPart1653724.kM9ukQj4WN--
