Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab2DKWHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:07:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56629 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444Ab2DKWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:07:26 -0400
Date: Thu, 12 Apr 2012 08:07:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: mainline build failure (Was: Re: linux-next: build failure after
 merge of the regmap tree)
Message-Id: <20120412080714.1b9fe574b18adebcc8af0ff1@canb.auug.org.au>
In-Reply-To: <20120411081711.GB3163@opensource.wolfsonmicro.com>
References: <20120411141346.3c4dd8e481d052b583ac95b6@canb.auug.org.au>
	<20120411081711.GB3163@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_08_07_14_+1000_l6Mor5dmPWE2a_hG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_08_07_14_+1000_l6Mor5dmPWE2a_hG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 09:17:11 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Wed, Apr 11, 2012 at 02:13:46PM +1000, Stephen Rothwell wrote:
>=20
> > Caused by commit f01ee60fffa4 ("regmap: implement register striding").
> > Please build test ...
>=20
> Mainline *still* doesn't build with the .configs I routinely use.

So, what is this failure and what configs do you build?  And has a fix
been submitted?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Apr_2012_08_07_14_+1000_l6Mor5dmPWE2a_hG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhgCSAAoJEECxmPOUX5FELt0P/i5hwH/pI/+4KOoiN9sAnFSH
usJbNFbPX8VufwD5oTPRbndY/mMxKb09HYOSi+eoCNXHCxSUEEInkCMWWlfF3QAb
TWWL/zolaznq8dY+ztEj4dSBVxZ3prpsCSwFzCDYGAKJFTFKgEPoEV8AOMS611EO
/LXKHZ7PNqYCg0XSuYlYNVl5rFRbNqHeHaEb1k8jUQL/TKWD+VU+1BXuibGl7KTC
vVK02DB5V5M5+/+gc96bJT0mgla3YHVWJkUvyAWQpwkLIEppKpDX5JkwsLnkZ8mh
DmGcXb8CBu+cmJ18+bX9+6vQqFOAwV4weMNpxHFPcBcAZtT6gqyX104j5lvfyD4n
6YEl0QB2mHsa2L06SAMDCKphj/zYdV1uVdmrwW2tV78aCKLBb8h4AF4lmu3n80Bw
exR+b/pGE3U1iNCdjQY/ldxDBHtZzQvzh7Dzd4y61ZT/7Y5heo90gFyerwP7nSLE
oo82sAX8ZyMYAUT2jF9//YY15+QjwOU7EZGbZSKHX9NgKaNhINKATePC9L21ef3h
M8VQoVVMmmbwPm4HhlaS9Mq92jrcGav5qOWbsYunjAkiuMdlZWRihXjLPwb0yzT8
7m+jjytltIYMQAxbKMjU210yMhkH6Qrlmzjeo3z/U+4WZN+/+eRivyvA040YSu/P
EisvUO1JsS0cncAa0aoz
=MGrg
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_08_07_14_+1000_l6Mor5dmPWE2a_hG--
