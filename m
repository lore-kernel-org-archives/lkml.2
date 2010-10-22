Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0JVKLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:11:18 -0400
Received: from lake.fysh.org ([81.94.195.195]:46604 "EHLO lake.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0JVKLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:11:17 -0400
X-Greylist: delayed 1062 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 06:11:17 EDT
Date: Fri, 22 Oct 2010 10:53:33 +0100
From: Athanasius <link@miggy.org>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: kevin granade <kevin.granade@gmail.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>
Subject: Re: On Linux numbering scheme
Message-ID: <20101022095333.GA10047@fysh.org>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kevin granade <kevin.granade@gmail.com>,
	"Artem S. Tashkinov" <t.artem@lycos.com>
References: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com> <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com> <AANLkTimqNW7zArcjtOkBvrn-dk=YE0_RG+u3yoMDTjwV@mail.gmail.com> <20101022020006.GF19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20101022020006.GF19804@ZenIV.linux.org.uk>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 22, 2010 at 03:00:06AM +0100, Al Viro wrote:
> On Thu, Oct 21, 2010 at 07:06:23PM -0500, kevin granade wrote:
>=20
> > Any particular reason not to continue the date-oriented format and
> > have the third number be the numerical representation of the month
> > rather than an incrementing numbering of the releases?  It would still
> > be monotonically increasing, which is the only requirement, right?
>=20
> Why do we need to change it, anyway?

  /agree

  For the most part it's only distribution maintainers that see or care
about the kernel version number anyway.  Anyone else knows what they're
getting into if they compile a kernel themselves, and otherwise is more
likely to say they're using "Linux 10.10" right now ....

  Having said that I had a lovely suggestion in the last round on this
topic which would allow you to know when a kernel was released just from
its version number :).

--=20
- Athanasius =3D Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkzBXxwACgkQSEDmQuIYzh2CKgCgm8K8jCgUseloE/a11aU37Yd+
EisAmgIWQYzH2WvNIa/TJgOni0amDj2h
=mpVF
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
