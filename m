Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2GaGbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:31:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53188 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2GaGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:31:16 -0400
Date: Tue, 31 Jul 2012 16:31:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sage Weil <sage@inktank.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120731163110.9315064260c09da3bc77a4d4@canb.auug.org.au>
In-Reply-To: <CANN689HeXEdnPQUnFzZ2E7nsUktqF70vCv2ANsYRz9HhyxVhXg@mail.gmail.com>
References: <20120731144054.59b0a6da6d071ea1bc061db0@canb.auug.org.au>
	<CANN689HeXEdnPQUnFzZ2E7nsUktqF70vCv2ANsYRz9HhyxVhXg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_16_31_10_+1000_s3j86J0BW1KIdV7M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jul_2012_16_31_10_+1000_s3j86J0BW1KIdV7M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michel,

On Mon, 30 Jul 2012 22:45:46 -0700 Michel Lespinasse <walken@google.com> wr=
ote:
>
> There is a good chance that this is the right fix, if ceph doesn't use
> the RB_CLEAR_NODE / RB_EMPTY_NODE macros or try to directly access the
> rb_node fields. I wanted to grab the ceph tree to make sure, however
> the first repo I found under that name did not have a commit
> cd43045c2de6; where would be the correct place for me to fetch that ?

These can always be found at
http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dblob;f=
=3DNext/Trees
for the latest linux-next tree.  In this case it is
git://github.com/ceph/ceph-client.git#master .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jul_2012_16_31_10_+1000_s3j86J0BW1KIdV7M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQF3uuAAoJEECxmPOUX5FEeCIP/jd0lhntvJ7/7CvOQTu04qDg
TQpqGV1Lqi4xkvt97LjUhqG8twR5jENWICU1RkcwMCOIxaegQ1SzgFpdA6A8P503
ymL2R0ItNQBJ00qU6gks3PaOcWoLEdD46JuSnV6exVXmJbsQ7bUpV0E2Qc3uJbT5
Ms2DtAjmHE//5p3vH6fRV10tgRQoB7jT5FtXjT5KWqu3sIcCw7Or3H/+huwwO2Xl
alvLknTlh3hGVcNgH3UNmxcxeDPint58SlQ6sMzjfZJbCtK57acNoOAvaWOn9CXf
wf5VVccmfA/aKobGLUVCrnblV6/uqd66mo8hvPiiZiyIe/En3iDJctQr0yvx8EnA
Yd+EDXlUvarmKdQM8bxflk74SawvSzJSPKdTTWisWdrodrNVZhUrostSdxSXq29d
92Mc9jGsAUJxGAkZnT9lbeB/ICCSA0abO6vd64P2Bj1G3mDMMTm+9K6WAZtdIh2V
xjSR1IMpaj1IWHB6tdjHZf8q1rjPpRrPOqe3l9B3izmOmm0s3iZ7El2XW7Hfd3ly
YF3DrPNiFa+kTDSDmJTpc3SpLxRZ0hlDlzr4CgS7VQl4wwDYqVuvMqssWRl6W9Mq
HuMfpuoJCCeLE7s/WTKJwAf9T72Z5usmtROU1+UZIz1BItgdtG+RbohCp5XPMrTk
NIk/NyY6Wxu4bBEU3Bda
=Yjri
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_16_31_10_+1000_s3j86J0BW1KIdV7M--
