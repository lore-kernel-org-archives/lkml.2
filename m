Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2DJQFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:05:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44487 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2DJQFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:05:48 -0400
Date: Tue, 10 Apr 2012 11:05:34 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: dustin.kirkland@gazzang.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] eCryptfs file system with HMAC verification
Message-ID: <20120410160534.GA3891@boyd>
References: <000a01cd171d$9e6c23b0$db446b10$@edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <000a01cd171d$9e6c23b0$db446b10$@edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-04-10 21:26:58, Li Wang wrote:
> Hi,
>   we have implemented a prototype, which equips eCryptfs with HMAC verifi=
cation,
> based on the kernel crypto API. This enables eCryptfs to detect unauthori=
zed (cipher)=20
> data modification and unexpected data corruption. And the preliminary exp=
eriments=20
> demonstrate the decrease in throughput is modest. As a file system highli=
ghting security,
> we think it should be useful.
>   Any comments/suggestions are welcome.

Hi Li - the paragraph above does not give me much to comment on but what
I can say is that an HMAC patch for eCryptfs was written years ago.
Unfortunately, it seems to have been lost. I don't think that the patch
was ever sent to a list but it lived in the project's old sourceforge
site for a long time.

The maintainer of eCryptfs at that time was also the original author of
eCryptfs, Mike Halcrow, and he opted to not merge the HMAC patch in
favor of using GCM for integrity protection. The HMAC patch was at least
his own design and maybe his own code (I can't quite remember), so he
wasn't negatively biased when deciding that GCM would be a better fit.
Here's a reference, although it isn't the actual patch review:

http://www.mail-archive.com/ecryptfs-users@lists.sourceforge.net/msg00271.h=
tml

You can find more about Mike's HMAC design in the design doc located the
ecryptfs-utils source tree.

So, the best way to proceed is probably to ask if you've given GCM any
consideration?

Tyler

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPhFpOAAoJENaSAD2qAscKdjgQAMB7oHrihZl0B/uUGNR8ua48
FyAlkl68XYpW+FBzeu/sKrwJOWFBxJ+M8A4jvtBfpXC2CLx3nk8XMazAmViV6BO/
l1fAX6gDn+cdE63ypBNr2rQI0lDTb0N8U/nc7Dveem6qJ7aGGqy66dl0al/avskK
lpKkSXCdz5c9AFMi1A4eEMnDaCRfr+g1PDoPh2SekSfX2b0TQK7OEEccEgQn2AEc
hS1rsvis7+I89wxrB5C8LzOSGXdPnq2iBVhpM53BbaqGVs/zTNlTI5JcHMzm0Ut1
xbwIyHQzYemnT5po86xcncR1xzjs/J8nnoWUV2TCpBa/oENuFbpHe92XCAopztri
eR0Ui3FiaFgtaJvMZCVrAkQmwn+Sqnb0xlMCTpdlOB0sx6PLj6TqVzTWVysybLwn
L3DwKTnqJnB7rRsWLVzs5abrHIc2FW9umIv58HzjDE5P+RSJb+WZmRVD4oHY5weI
f0C0vWsdJjGRJ8QR/xqXs2gmKR6Xlgudn61B7D2PJwd/WjgpSaWLF3FHxPKiuFTB
lintu0Y6bAeE9bro6Job8DOcDHlSimy/7TG+3wkN+9Ah9dAgRGFUfAA6X5M38jfi
IiB9De1ut/Buq5t/Lo3/eckA1HXF6AVHTE7gmbwnux3QlxCkihl1QG55OvYuMYAI
xOLlzixFFL9QePd7TZIn
=uFx3
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
