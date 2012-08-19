Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2HSTFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:05:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49241 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2HSTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:05:04 -0400
Message-ID: <1345403092.1930.4.camel@kyv>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Genoud <richard.genoud@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Sun, 19 Aug 2012 22:04:52 +0300
In-Reply-To: <20120819100946.646cbb8a@pixies.home.jungo.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
	 <20120816115713.726da8f2@pixies.home.jungo.com>
	 <CACQ1gAhFJ6AKYJpc1ZiHm+3Y=APnwUmVL3f0KW=OFMDMWzCVJg@mail.gmail.com>
	 <20120816134234.32b468f6@pixies.home.jungo.com>
	 <1345124012.3393.239.camel@sauron.fi.intel.com>
	 <20120819100946.646cbb8a@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ik5G9eFZxGIKm10HIwG/"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ik5G9eFZxGIKm10HIwG/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 10:09 +0300, Shmulik Ladkani wrote:
> On Thu, 16 Aug 2012 16:33:32 +0300 Artem Bityutskiy <dedekind1@gmail.com>=
 wrote:
> > We do not have that big user-base. No one uses 0 in the tree, most use
> > the default. I never heard anyone using 0. I did not use it also. I
> > think it is OK to have the lower range start from non-zero. But why it
> > is 2 and not 1 - I am not sure :-)
>=20
> Artem,
>=20
> Note that originally range was 0..25 (percentage).
>=20
> It was changed to be 2..256 (per 1024) by 07ad322 in linux-ubi.
>=20
> Seems arbitrary change.
> So if you'd like, we can fix to 1..256 (or 0..256) - as you prefer.

Yeah, I wanted to make it 1..256 but forgot, will do now. 0..256 would
need some more work to avoid division by 0.

--=20
Best Regards,
Artem Bityutskiy

--=-ik5G9eFZxGIKm10HIwG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQMTjUAAoJECmIfjd9wqK0V+sQAI2TWKSc60QnB2+eLnRgCfN5
2WG9EEp5KGF5ytcjKVMH0GK6ceXIE/IYIhANUqm7Fv0itK1iLONpM8fqd49X2uhz
ZSX6/QZ6XV4M7CzOnSzGecQb10gNB40XY/1JgkLuU4IzLy+fOh0nT5PFxpYTBUEI
1y6riIyQ4VY8DQ0opwyeifbzsxwdJypJqWioWIiXc6zx0hizTvuxcycmqUeJthxJ
jIVQMtJY6nTAfPJd4fpjXJD4mtWopPCuoOmcbNQnrNJfXAz3j22DhTWhiOR5y4DE
VASu+1u36OLc6h/q9iHrENJSx5VbOx29uXeJFt82MIqJyTknK5Qoi8H8CzuBNZKp
+GY36e7qjKdhTQgVEk5TNUI9qZ6RaQDmlQM39satSmERGvphEN2UrEw4CaSznvRD
0x4I85tlHnToLRaFzUT3HvttvcIG4Q8Dpld/xd+eFVJY0O/1gKkiG/rIoYrS+Av4
C8+5/X9Pq+MoAuJkCSbAmbNWVlJuYhJSnl28ORVUaEhHYP+tk8omypgzicvvswT4
35b16yLJw7GwKdcl/wh3pourchoXYjD2CMVkdn5f5UibAV31+nzoiiqPTAbX+pTZ
g5NJTi+uzW2PkefkmHqvFIPJD42Nwn2g+DY+q2XBh8Zj0KQJDOeyWiGjfxR3Sb+6
CB4grFeiOdD+fK2v0v9f
=LZHI
-----END PGP SIGNATURE-----

--=-ik5G9eFZxGIKm10HIwG/--

