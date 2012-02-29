Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2B2MHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:07:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61933 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2B2MHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:07:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.184.199 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330517388.3545.109.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: tglx@linutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Date: Wed, 29 Feb 2012 14:09:48 +0200
In-Reply-To: <4F4E0E9D.7090002@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1330515322.3545.99.camel@sauron.fi.intel.com>
	 <4F4E0E9D.7090002@linutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PEOd92CWVvTO/6AKsGSP"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PEOd92CWVvTO/6AKsGSP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 12:40 +0100, Richard Weinberger wrote:
> > Notice, your patch-set has huge amount of checkpatch.pl complaints -
> > please fix them. This will also be consistent with the overall UBI
> > coding style where I honored checkpatch.pl limitations like identation
> > style and 80 chars per line.
> >=20
>=20
> All checkpatch.pl complaints will be fixed.
> But first we have to discuss and address real problems.

Note, I just have a maintainers script which takes the patch-set as
input, then checks bisectability, finds new warnings, checks with
sparse/smatch/coccinelle/checkpatch.pl etc. I just gave your patches to
my script and checkpatch.pl complaints were the only things identified
by the scripts.

--=20
Best Regards,
Artem Bityutskiy

--=-PEOd92CWVvTO/6AKsGSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPThWMAAoJECmIfjd9wqK0fxoQALczd4wdgwFK+19jBd16JnkA
aj9lbWLplPMcNT/eSOxV7V0JbTHeTwIpxUM9vPVUMYJwgiG2M2xxI7jBPeFquka+
7VWgAAo6nfA+Lqx+PIqdYWiyueRBPhq0mHJE7YgD9FX8p0WWQECsd8PBDAJAYLhl
X51jhnU+t+cKnEqfkX6II7zkbUmsHlpy/avPkIR8dnvGAh1spozrWU2i1JK1umE+
u833GtKmhg7+H6h4VHYgtjatbbR1CdCTgs11i+Y/FIrCumWmhB7NlGNDDaoRZ3Qy
ONPTvljBrZW2IgmVS6LE+10Xj5QGoeZkplPFwgEj+iP8BdnbaJgpKnnNGQwhzYb+
3pTyP9esQzFgmqu8V+Q69X4bXVmsOTMTBQMOkVkSxz9dUpz1gvGlx5jeJK+MQUtu
ycHe35ySEJTch2e2zSrzJbHVo+ZllzXCSb23kjCa9f0LzeOuWvXCL7b2aphXp7Ey
9vjpV6PIq8cCSny9DZVFWq6vTus6kPmwdPfbelaUmmu/iCu7caRrDPOxovaRurib
rpsBLHZcoigJy2Z6XpLa4K/HhWGOfqPyDbaHm93S/Zfob2l1wn2sSnh+53uW8S0s
+TwcowYGnAtWVwfUBvl7aMNjfHwHGdrGY6D5/yDBtbmM0C8ZOTYiur706zMwJHd+
GZUovrwPk0FfPoLp47dW
=1KLZ
-----END PGP SIGNATURE-----

--=-PEOd92CWVvTO/6AKsGSP--

