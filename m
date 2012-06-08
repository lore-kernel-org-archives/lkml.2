Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484Ab2FHWyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:54:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab2FHWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:54:20 -0400
Message-ID: <1339196050.21665.128.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/82] 3.2.20-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Fri, 08 Jun 2012 23:54:10 +0100
In-Reply-To: <1339164246.21665.119.camel@deadeye.wl.decadent.org.uk>
References: <20120608041840.861504477@decadent.org.uk>
	 <4FD2012F.60309@gmail.com>
	 <1339164246.21665.119.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xRuF1WiDgl0OsxiQxtA+"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xRuF1WiDgl0OsxiQxtA+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-08 at 15:04 +0100, Ben Hutchings wrote:
> On Fri, 2012-06-08 at 15:42 +0200, Maarten Lankhorst wrote:
> > Hey,
> >=20
> > Op 08-06-12 06:18, Ben Hutchings schreef:
> > > This is the start of the stable review cycle for the 3.2.20 release.
> > > There are 82 patches in this series, which will be posted as response=
s
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sun Jun 10 13:00:00 UTC 2012.
> > > Anything received after that time might be too late.
> > >
> > > A combined patch relative to 3.2.19 will be posted as an additional
> > > response to this, and the diffstat can be found below.
> > Is it too late to nominate patches?
> [...]
>=20
> It's too late for this time, unless there's something really urgent or
> needed to avoid some other change in the rc causing a regression.
>=20
> I'll queue these up after 3.2.20.

I'm sorry, I see you already requested these earlier.  So I should have
queued them, but anyway it turns out that the last one (commit
a6a17859f1bdf607650ee055101f54c5f207762b, 'drm/nouveau/disp: fix
dithering not being enabled on some eDP macbooks') breaks the build:

  CC [M]  drivers/gpu/drm/nouveau/nouveau_connector.o
drivers/gpu/drm/nouveau/nouveau_connector.c: In function =E2=80=98nouveau_c=
onnector_detect_depth=E2=80=99:
drivers/gpu/drm/nouveau/nouveau_connector.c:620:18: error: =E2=80=98struct =
nouveau_connector=E2=80=99 has no member named =E2=80=98type=E2=80=99

So you'll need to provide a backported version of that.

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-xRuF1WiDgl0OsxiQxtA+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9KCkue/yOyVhhEJAQqp6RAAwT3hhZ4xodSeyl0tGde8nZ7OBg01431B
DLG7jXGEYZAf+8+zcRIz3wc5id1DvhoDoJCqMH9hjXMv9+yPQh7uSa66H9sS7JSI
o6sWWaPj/7QjCjmLYRAqdyRhw7+XfQXM5YiB3jKXZeu7XVYxpt/puM0X7JZqKJQA
xHchjZDIsk5nhnQuzKnXbglhT/5k8TY9Of0ibMA32SqDORrRgnyF2VWlatLoYPaz
/2FAI15wxNIVjcYxUhlVF0d6L5cec4NJwNlDDdj3wt70gMIspPw7lGjYzeCOmOMK
y+Nq32xkhhbTphK3dqZ2goX7HeHQ0P0YQY+ZGDRQS9YDzxU7lw2nGMecy35vVXpa
ByEFzjyEb2D/QS0ojY+QO2hiwuDmsZL8WfOyGQ/roiPYeAxwSEg2o9t+1XAwtlOz
j0Dpt0aZBa4xUp5wZPdZJoTDlAGmrMsIkDgO7uem95UUUsVHD3+ZibVjJ+AQ0ho7
/f3TrPwRPsyzC/B1pZBdTlf3OiOIDroU8rc2wU12bPoRptKsQE+/dfajeq3MOCS4
IkMf/Et4sXBKUT/w0/TexmpbjJ+BA8EeEFZbFvNSu9QiSPu5WPs7gnqErIAUQ59i
jKySO+57YaKgaaRLEQVCtfy0YKPOVoD0RZCrvLwFkEKzeOHPRvkMDNpy2XdUIQJd
0ofbjxn4HpM=
=iMMQ
-----END PGP SIGNATURE-----

--=-xRuF1WiDgl0OsxiQxtA+--
