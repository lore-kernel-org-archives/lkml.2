Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1KGJvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:51:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49992 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1KGJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:51:09 -0500
Subject: [GIT PULL] UBIFS changes for 3.2
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 11:51:14 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-A9qAjy11BziY+53YOSFf"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1320659481.21852.10.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A9qAjy11BziY+53YOSFf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please, pull UBIFS changes for this merge window.

The following changes since commit 93ee7a9340d64f20295aacc3fb6a22b759323280=
:

  Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (1):
      UBIFS: introduce a helper to dump scanning info

srimugunthan dhandapani (1):
      UBIFS: fix the dark space calculation

 fs/ubifs/debug.c    |   16 ++++++++++++++++
 fs/ubifs/debug.h    |    5 +++++
 fs/ubifs/recovery.c |    2 +-
 fs/ubifs/sb.c       |    2 +-
 4 files changed, 23 insertions(+), 2 deletions(-)

Thanks,
Artem.

--=-A9qAjy11BziY+53YOSFf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOt6oSAAoJECmIfjd9wqK0C0IP/REc+piReYEN7FtDt5guvoET
hBhELSpIMFfIUOgtNOB3Op5dnofnCLGN1n6UkmNa67oKv5pTCDCIVc2gPQfHAVSz
Hr5kid8BPOFp8HLbIDXYpYvhw9csL0W7Cl3keHL5XF5V/4wGpHxcgb4BadiWzkjW
waVBxY/pqrU8Mqdq8rhcS4vQSe7Z1Rvbiz6mG2JNoG9kyilRMIiOlYFUa4PXC1jb
BUE1ewsvwlevHv2xH6Tp4pM91OTmpdcYShztU5JZEznwjvd3T86Nfv9rW68uGJZX
NnThpoTXZbmp2XIJW9WVUey3S6CZvkXLj5fs7wMOc+gkn4tOkWjIUJoC1rZbHh9s
2383kK5ZmDhWFbTJmfPrfsgJeWdSY4vD856foS+VufEc2zFBUHMWampEcKIwmq/R
q2FVQgp4M61NxN+xndwzmnZUTWHPvWOaIb4OPRTKfr9KqbmNKqBIY8V4EKi5ETj1
M2lPU2o+X4CCaM8eVkuae1y6z05BAl+xh3L+tzqS7HL3nMikSTMGKR2xY6qTM2/V
PzLESVn9dUa2XJCuoB6ZlhR85arK5T1lsPy1UmkhO/+2zF2A3CQrvb9WfMrpB4Rr
xTUWsgl34JyKDODzEMr5w1JWrod9Gl7c4ZZyxWyR0aw3qo0hc5xiPupi8u68SsVY
2s7O1o4P0PK3w7eMZ9zi
=hCAI
-----END PGP SIGNATURE-----

--=-A9qAjy11BziY+53YOSFf--

