Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2AWQ52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:57:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab2AWQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:57:24 -0500
Date: Mon, 23 Jan 2012 10:57:15 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, john.johansen@canonical.com,
        dustin.kirkland@gazzang.com, Cong Wang <xiyou.wangcong@gmail.com>,
        Li Wang <liwang@nudt.edu.cn>
Subject: Re: eCryptfs: Truncate path improvements
Message-ID: <20120123165714.GA20665@boyd>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
 <CA+55aFzpM-c9FWdC8+7sV0GOXqvFNvxPsrV42rvXJHXnKsDoZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <CA+55aFzpM-c9FWdC8+7sV0GOXqvFNvxPsrV42rvXJHXnKsDoZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-23 08:49:40, Linus Torvalds wrote:
> On Fri, Jan 20, 2012 at 2:35 PM, Tyler Hicks <tyhicks@canonical.com> wrot=
e:
> > As Linus pointed out[1], eCryptfs needs more checks around its truncate=
 path.
> > The first patch in this series makes it possible for an eCryptfs trunca=
te
> > operation to be gracefully interrupted by a fatal signal. The second ad=
ds
> > checks for eCryptfs inode changes in setattr. The third is simply remov=
al of
> > an old, unused function.
>=20
> Tyler, should I take these patches directly? Or are these just for
> review and I should wait for a pull request?

Just for review, as I'll send a pull request.

I'll try to be more clear about that in the future.

Tyler

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPHZFqAAoJENaSAD2qAscKU7oP/iAxoxIUAb7NbmrxwRv0Ma01
C9I/I0u6reXXtv1APTshUmbwjCqXKBmHOolR3gkXud8i4EvTbL7RHn5mF0/IGnNg
m+FCi++kVd9IIu2KkfqC2pvmrFlKrXs/PXe2DL1cbrqLmF/6Pn8s/phuNASo4UIK
nqNBwz67b+MNfuZIdQ1of0WEtCxg4EnF0gjHTDDdeAbV0sBZMLbyD1V0Vq5nsO+V
DngVKOxDzM4N4Mh97e1PSzwjVmSedSsVmVXd0GYkEsXDkaLI084NTvn16WClFW6G
7q4XWjxqnsmkI5aL4uz381B8NX2hWy6llim01p5LzYl0I9EMY4y9F9g4ZMqBAF8F
tBNCNoJBvq9C0THPIUY+3820icJggrsdMq4AuU8BEn/P6mSChsIdC7s5AKo4Uk5M
PPGopgtNPp/NkJz/CTDBJTBlyKHpTjw5s/QMgcv1/zevR0LnqdTIOoB4BOgZ7+2g
Sm/4ViCG3EwARjfgQz3ZiiAA87AHrW/EncBq3LTqyDv1MfgOq57G1GhEX5+dmHT2
AcYQr4wiqEqcHaW9+959zMWHNUNv/SGKgObh5ogoagUiWU2xiZLcL/KRru9HqER0
dDIJqAjSh8uGT1F03xIWNYk18dXjwGNffEUBnI+bHI79uEmMPWg/GSxkhDa4Uz4m
4Giq1Mnmpij9m1xeEuHb
=TWEd
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
