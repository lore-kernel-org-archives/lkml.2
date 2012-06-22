Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774Ab2FVI7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:59:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761732Ab2FVI7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:59:19 -0400
Date: Fri, 22 Jun 2012 10:59:09 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, Laxman Dewangan <ldewangan@nvidia.com>,
        lee.jones@linaro.org, lrg@ti.com,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120622085909.GA24121@avionic-0098.mockup.avionic-design.de>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
 <20120622084228.GD4037@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20120622084228.GD4037@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NyVTX/nt9afpcNR/sKMV01kxABQRx+q3iNNqGFcyBFq
 fefYoVsjI082cdYjMpSbTe0XMI+GCdtZJ3OLm/EDIdlz0HtLPj
 hcGdBcDLr5fyCnicKIhYl54BUOx5whnbAf5bekyPjoHl9aIa8r
 4ryatNY1RcxIrcdXwb8JUaKH+fwDSZBcYa643L/Pz6W+whrePb
 i3EDZ+zurDpwmJWOqYtpkdrK9EmYecaZhj3bEs5JoLlNsIy+DB
 Rr4gwRfWFhX9QZovNYXf9/84z+HINF/9WJypGYbvnwYKse1yt9
 dWjlu5SI4DMP6Qam6eh/iipQvEBjf4GzBuVfjE6Om7INvGsYJ+
 YtJpfOJbwEgwrKJSV7pv6ICJyypO92aCpPFYyO3iSpMj5+f/tn
 KIODSEp121FtYtVzettZHCADvo/41Q6c/0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 22, 2012 at 09:42:29AM +0100, Mark Brown wrote:
> On Fri, Jun 22, 2012 at 08:13:14AM +0200, Thierry Reding wrote:
> > On Wed, Jun 20, 2012 at 08:46:10PM +0100, Mark Brown wrote:
>=20
> > > As well as being able to refer to the object from within the device t=
ree
> > > we also need to be able to tell what the object represents - we have a
> > > bunch of regulators in an array under a node for a PMIC and we want to
> > > know which regulator on the physical device each array entry correspo=
nds
> > > to.  Previously this was being done by parsing the phandle name but t=
hat
> > > means we can't have more than one device with the same set of names.
>=20
> > I thought the reason was that matching the node names up with the
> > regulator names was considered bad practice. As Stephen already noticed,
> > the matching is done by node name, not phandle. Correct me if I'm wrong,
> > but you can have more than one device with the children have the same
> > names.
>=20
> We're talking about consumers here, not the regulator driver finding its
> own regulators.

No we're not. of_regulator_match() isn't used by consumers but by
regulator drivers to parse the DT.

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP5DPdAAoJEN0jrNd/PrOha60P/ikoWaqHl+rPk11BuQC3RPFe
YB65YSvguLbedZIDLWilEWq/Th3z8A44vLbj9esMEA0A0AiiDgL5Jfmn+Vm/mof2
uuY63lXwOkfZGoE3CwfrAiBw1SezynU5SoqN4hzWBrX7ZyM+p0vmCQLFviZV5Ulw
82UNgtPcSwrKmdgr7AoeECPOvHQHQTlxiJ11WfueNNs7vr8VLluQ4zPyaILPiMcO
by+l7M9FVPyuIK3Zu/rRbflBdCtPjYlEMMdi5TNpzZoxUteklFtFHpULwY18LJ0T
sFcuopt8eIXlcmyxw7g43YOLBvmKL8gJ5TnOwbyzNP7lL7dNMNTlyK4CSFfUyuJN
hv2hoTSzFmFw/KmLxjOOSARYc3aY6nzQ4quV6jPn4ffK3DI4+DXdAquZr05Altb2
onhhc42nPN9cWC9ZjZXUJul9Fi3pbuvmFNU3Q0cQRjwGGOO/b04D6BTqa7iIJnCO
0ASuTQIW1HCekbJu1LUsqqyU13Z8MtgpcHh79cylTKoZELkl8XqhIiAHz52gtZ4K
0E7qHDuGX+t+knXC9S8yAiuRCIGizlbp+16q7VnPbvOaMSaakuFwACU98kHl3hDX
+pOh/XvyOzeStzU0gz3qcyIAg2ibJOcc8E1AgYenguCBjDlAtDZ82Q1z1N5bWsK7
ErWZHsYWlMlZZAzQiYy+
=eLev
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
