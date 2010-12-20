Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0LTEnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 23:43:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46821 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0LTEnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 23:43:07 -0500
Date: Mon, 20 Dec 2010 15:42:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Ik1pY2hhxYIgTWlyb3PFgmF3Ig==?= <mirq-linux@rere.qmqm.pl>
Subject: Re: linux-next: build warning after merge of the block tree
Message-Id: <20101220154259.9a84819e.sfr@canb.auug.org.au>
In-Reply-To: <20101220153127.ad8213b2.sfr@canb.auug.org.au>
References: <20101220153127.ad8213b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Dec_2010_15_42_59_+1100_4wmjb1yZYE3sG7gA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Dec_2010_15_42_59_+1100_4wmjb1yZYE3sG7gA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Mon, 20 Dec 2010 15:31:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> drivers/block/loop.c: In function 'lo_splice_actor':
> drivers/block/loop.c:398: warning: unused variable 'ret'
>=20
> Introduced by commit a8adbe378b56acd5945df70753c7e8f6fe223304
> ("fs/splice: Pull buf->ops->confirm() from splice_from_pipe actors").

Also:

fs/nfsd/vfs.c: In function 'nfsd_splice_actor':
fs/nfsd/vfs.c:848: warning: unused variable 'ret'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Dec_2010_15_42_59_+1100_4wmjb1yZYE3sG7gA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNDt7TAAoJEDMEi1NhKgbsgrcH/iORCXtsUkDXFU7d9SME/+BS
GygCPPqsuOz0w/dWm8cO+DseY6zT7giFvEtXwctLr+j0PEPFTvwdwVuKIO2eG1ir
xm1//IFnjpSEWw+WdyOdE3yGD9HrKkDuPVlMaFYfRRuskxtI41nea1g2BnBGUVY8
LZ63ZZt13y6/bI/Tt5olZ8HZvgZvitV7MsWxccJVaRhKpt50F5O8KgbXSN7t47oZ
pWhJ0zNZiQ/w5H0mWtFO/SqiDdMVWjeBAbWbv8IAZoSseGvobm/YXVzpxwz1F5FH
fqe9tbeOPeu6mKkoWv3z33ZuRQUSIxa7xsCHdEiNI1859BoFAAF2soZXodygEik=
=SFzK
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Dec_2010_15_42_59_+1100_4wmjb1yZYE3sG7gA--
