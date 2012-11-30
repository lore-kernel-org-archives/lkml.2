Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2K3GxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:53:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2K3GxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:53:06 -0500
Date: Fri, 30 Nov 2012 07:52:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121130065234.GC26474@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B7AB93.5060207@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <50B7AB93.5060207@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WiJph9LaFZUa7ryG+c99h5sGP70Ui9xhHQiFt3C65Es
 pNxXidPlnSJfFm0lG3XlFBQbWOErB7lt6erOhfWjhgl7js7JUV
 N2rL3x2QV7PYpVKRLXc+guDeBe/witkDNpvdVwRHGQv9LVd8el
 yLzBxtNqOzLotlVgL8pXLdWniOhM7NswN2aKKeJaHiI4dEQu+j
 5XXAMZm7Eh7INS/RCWxaq3ThWKfJoGpXZh7zx8OUJs1qAgyDBl
 dCiOY3fDHGcB0E/0FnSasakpG8xyw+V/B5nzBA6/OZjy1/rMcd
 v6dxMdFdo3C3gknUOPFSqBq6rloXxNGaI05JpG6/3g31jX031l
 eGDYi6DfPChRImsxonqW95ra8e8XeJHOkmGrSIC1pLGbjHX73I
 +VsHqiqs0PjuiMD/oGJltgvxEwACOkVW3Sg6svYc7Mb3uzihBz
 c7HjA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 11:38:11AM -0700, Stephen Warren wrote:
> On 11/29/2012 04:47 AM, Thierry Reding wrote:
> > On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergstr=C3=B6m wrote:
> >> On 28.11.2012 23:23, Thierry Reding wrote:
> >>> This could be problematic. Since drivers/video and
> >>> drivers/gpu/drm are separate trees, this would entail a
> >>> continuous burden on keeping both trees synchronized. While I
> >>> realize that eventually it might be better to put the host1x
> >>> driver in a separate place to accomodate for its use by other
> >>> subsystems, I'm not sure moving it here right away is the best=20
> >>> approach.
> >>=20
> >> I understand your point, but I hope also that we'd end up with
> >> something that can be used as basis for the downstream kernel to
> >> migrate to upstream stack.
> >>=20
> >> The key point here is to make the API between nvhost and tegradrm
> >> as small and robust to changes as possible.
> >=20
> > I agree. But I also fear that there will be changes eventually and=20
> > having both go in via different tree requires those trees to be
> > merged in a specific order to avoid breakage should the API change.
> > This will be particularly ugly in linux-next.
> >=20
> > That's why I explicitly proposed to take this into
> > drivers/gpu/drm/tegra for the time being, until we can be
> > reasonably sure that the API is fixed. Then I'm fine with moving it
> > wherever seems the best fit. Even then there might be the
> > occasional dependency, but they should get fewer and fewer as the
> > code matures.
>=20
> It is acceptable for one maintainer to ack patches, and another
> maintainer to merge a series that touches both "their own" code and
> code owned by another tree. This should of course only be needed when
> inter-module APIs change; changes to code within a module shouldn't
> require this.

Yes, that's true. But it still makes things more complicated since each
of the maintainers will have to do extra work to test the changes.
Anyway we'll see how this plays out. The ideal case would of course be
to get the API right from the start. =3D)

Thierry

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuFeyAAoJEN0jrNd/PrOhOI8P/inHtC84X2k7WjhRqJtOxDHs
h09MgHk00hge9NCHdo/UKBQgFCT3/VXHzBoft+PYND1kwVK67QFN7OdRFfzDiQHL
ntHh9LxOMzgsHGgzvOl7PHivjQW5Js/6K+n2Ct3UQTup7FDbGub1piW8ftWVugA3
Alv56GZIVh4YlmO/p7stLNknzg4JX9SecQ+z+zS47VbEl8/7kSODdiBdTnYF/slr
JHXylWHsG7IS+c4wVsd4x1bJYJWqItOoJzGj0aqMUXuf3vnTsh5yKm3NKQDUTbEB
20PqQc3ZCRjfK2Ziunx6iWElbiFIUcRWwqV23BufKpLQNSHZTCgtyMOBUMY5Yxqb
YJz5JkC1OzPXYYh31LNnRFv+8XPt1oBuJEBwErVWBWB4BNF0Uj95JDsBnq4D2Z+t
qOKeM51NGzmoDZ4fvC9m9DSadyJQku1aB5dLTViWt9mUPWxkx0RGjvrBfcG3r7EK
c0RVBlp4Z3xqDhZamqbnpwUB7zDs5NER1hsJuLeCpaC2Hvu3O/7LD+pMlDLwvy9g
dd9zPm8183FxANrWoJ0YZAtymWcL7oQEiaYqNCApibyIfvXMgGi3lnAR7JPLpTpn
SYe4dApnlKRo8Nq1vxwJ0oT8m8pzYKtyn1Bl0HEITI2msAdVmZQSrS40yAJXglup
hPx9XQ4dHQghd3IuSqGH
=8WVF
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
