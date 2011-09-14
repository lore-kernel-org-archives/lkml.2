Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1INAsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 20:48:32 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42703 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1INAsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 20:48:30 -0400
Date: Wed, 14 Sep 2011 10:48:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20110914104824.16160f72661c1c9aed23ee88@canb.auug.org.au>
In-Reply-To: <20110914103234.4f2f6a2dd65734de6622e79f@canb.auug.org.au>
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
	<4E5690C3.2050706@goop.org>
	<4E5693DD.2010307@zytor.com>
	<20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au>
	<4E56D6E1.6030405@zytor.com>
	<20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au>
	<20110913211154.fe53ca8c1d608def77a69022@canb.auug.org.au>
	<alpine.LFD.2.02.1109131706410.2723@ionos>
	<4E6FC2D3.2060408@goop.org>
	<20110914103234.4f2f6a2dd65734de6622e79f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Sep_2011_10_48_24_+1000_0ctT/sgN9k55.IZK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Sep_2011_10_48_24_+1000_0ctT/sgN9k55.IZK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 14 Sep 2011 10:32:34 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> My understanding is this:  I do *not* need to revert the spinlock changes
> from tip anymore, correct?

Right, having looked at the tip tree, they are not in there any more.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Sep_2011_10_48_24_+1000_0ctT/sgN9k55.IZK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOb/nYAAoJEDMEi1NhKgbsXEsIAIDmUD2cfdqjI/TfpSpST6Rs
AhZXGrApARWTWVaT93/pNmnAWPXEpBYUPGgSVDSK2Ru9jatXzvHOtnm/r7U7pP0V
Yvp7dCfnX+DVWTFDNnLVguIwq5uz9isl2MLHuxJeXeB5Ch6d8yaX5/WERhZ5VB6p
iqQQQ7/M9ueV/xa0bQQWkpPyUVA+M+PzT7Tv2hSMLrHf1ptEufVErpWw4qNaXx1t
nhf4wgK3EN+oBRWp6MHlXMWxrMTv5sncLPj/H2ZaP4uLaDACyAjQtREn/2H9TSAG
1Lia2IXEXRrzTV3FLZg/pFc70RQwy4mSfCpw7YAF/9wzHBOTWCT182cvb67OP6s=
=g6tw
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Sep_2011_10_48_24_+1000_0ctT/sgN9k55.IZK--
