Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2DQDZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:25:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55486 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2DQDZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:25:18 -0400
Date: Tue, 17 Apr 2012 13:25:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>, stable@kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20120417132509.71a0347a9ca043c60274191d@canb.auug.org.au>
In-Reply-To: <20120411121058.088008039d669521e9afdfeb@canb.auug.org.au>
References: <20120411121058.088008039d669521e9afdfeb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_13_25_09_+1000_0AQhvNIr88jaKlME"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_13_25_09_+1000_0AQhvNIr88jaKlME
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Wed, 11 Apr 2012 12:10:58 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> ERROR: "__kfifo_max_r" [drivers/media/rc/rc-core.ko] undefined!
>=20
> Caused by commit 24a19bcbceda ("[media] ir-raw: Check available elements
> in kfifo before adding").  kfifo_avail expands to a call to __kfifo_max_r
> which is not exported to modules.
>=20
> I have used the v4l-dvb tree from next-20120410 for today.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_13_25_09_+1000_0AQhvNIr88jaKlME
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjOKVAAoJEECxmPOUX5FEGdgP/R9pXEAI3FWopcjY5AXabhaE
F1hHniiaLPQCRrwsW/UC1EbjSHbyxmPCI8/j1d0Nyjyi7kINQ7oLylBznf58nSCI
TOczr8wrS04/uj3IIJJZyxXFOLytYp+leprwuSp7iTW5wUm2i8r7ud9BFtOrGPSF
TlyLU8cXdEKRk6WqqUTHss3Qh+gjooJBpk1Nd/dgH8ODMRVKVuEzSErFnTIeiSDW
rTWAHonoKBciLgjqkwwBQDi/xuaXBRWcTbOtAjBn6xnsvqQRLOls26bqMwLcuZsR
3tLRv3LhwZLM1Zs320iLLLh1xt89Bf21PMCcV1khPIT0kE0IphNOZGl3EPLjHSOU
1N9crn1ucciK0IPgXjuSMvPVUmrlK3GHE7Oy7ho4WVi9aUFnKcTjtO83uM2V3Bcl
SZKZXlRbEbzLeMPGaE2Igk1yg5+84xokTFIUIZ5bud+g41GpSJFR+uXMSqUYis8o
3cpc1mbJeD6jDzCwByjhhGAakWMJw9Wl4Ql9PYCupq2g6JkmmncOls+I1ODd/2Hr
jhLOiCD2aSZ5qLTfgaIjQT2Y+8Pbg4ktyd03EQe/sVKPJWPt/qSvJFGnprc3lw0d
Ep5XKZnaI6fRYAHKMsSXvPtZ9eMUzK+cyNv3wnzTTkY90vsxEm1Hfc3bqfiCw039
2KJN8EodF6kjDHE5CIXX
=wX9M
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_13_25_09_+1000_0AQhvNIr88jaKlME--
