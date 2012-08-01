Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2HAHr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:47:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2HAHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:47:57 -0400
Date: Wed, 1 Aug 2012 09:47:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120801074742.GH29673@avionic-0098.adnet.avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120731172638.GE16873@home.goodmis.org>
 <20120731174249.GB4735@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
Content-Disposition: inline
In-Reply-To: <20120731174249.GB4735@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:SqW882SMg+IgMHMxevSp/nIken/O6NN1H1ulN8JpaK9
 FkHKOWLsEnf79a9rajNc5sQ3ITMkAFi0GUPHjruPslADg+LpNY
 uSfShnY9xThAJLSWjhxZqp6IhBeqWQWhBt+EL8itUU2gt6VROm
 HRGIkHeVnRLAb8qK4AwZYDgkTaeLegrtVFDH3Gn7bzAMjqzEm4
 qKyutjAAQcUh3RzAsKzwY2TeQOaHvZq/uaawtP0VlND5/2SwDN
 J7ZjEDsJmidq2C4XDZ7dKRsrB+nezUMOfaebg8+33HJ03bDB9G
 CWXF71V0E1jZ71CQkz+ToAtSaBEA2P+wE0z4UHUAGO++Ni0dO4
 DC/nr5zW3UjmpJHqGFzDbO9eKVwHl8t/N4v/Skqibm/U/HtyiE
 vwHKg+6Qc3J1Z+JbF94Knfq70DVPpHdm6ydtGEe3eDrK10/cF7
 1gNZ6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 07:42:49PM +0200, Borislav Petkov wrote:
> On Tue, Jul 31, 2012 at 01:26:38PM -0400, Steven Rostedt wrote:
> > Then shouldn't this not have a prompt and just be selected by those
> > PWM drivers below?
>=20
> It gives an empty menu due to the deps of the single PWM drivers.
>=20
> But the whole CONFIG_PWM thing should simply depend on !X86 so that it
> doesn't appear in drivers/.

I don't think that's a good idea. That would mean I would have to add
!SPARC and !S390 and many other to that list as well. Also there are a
couple of drivers that are in the process of being ported which are not
restricted to ARM or embedded in general. So even if we make this !X86
now, eventually it will pop up again.

Thierry

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGN8eAAoJEN0jrNd/PrOhPikP/3F1IEyhYM2lRDIejuVTN8UU
fwYgvyAPJ9gSj9K+9b8djNS6t4rqnM5XZNm/7SSy3XUQMz8jiWXK0NMDNkZrRuh1
VAt3ug6M+fj5S3XGquuCw/AvZMbvScyMFG4witjDBO0ZlNPI0KQuKqZeM0KiBili
GZFl8k9M+oIJmOmA5EK6TZr37Y3JkYw7EJ+1gILMevBqJuZHoyvdADhivLTuthrd
PAjfGdZZ6RNo6D5MTeArgw9tbyrUdwMsm80x31HCB/WaqGA6HCkgZ2RgYJK5hbBt
wUnCRrCKz3lnldHLhSBA4BDlHsr/usMOSSq5wVsW5uxOEuGGrLizzFTRiDl5C6vr
YH8qDcXFKX91xZjWeq9PolkBktQDY4JX524w6QyoPl3YZPOS/GOJT3AF9JnLVo67
zzZttVcsWT4lNAK2Sj/qmaIr3xcukeYjFVSkF9ihzjkL7uK/8vgk05zVkHAbmFR4
XYoiog8/pxL1FJc14THSS6aCUXcByOHuoOwRdVUa51ntUfY/BVa3lxiQhq+dU9BP
ln7zhZwic/vyBqawl4c2saYP3e6aVf/X4cCNM42eMhXa/G3L7cC944gRtZZKqbF+
YHiXaW26mLpGsbK1zK/ZFyN+CTnHc7Z2DFiZLaRkXKIHVT+0ZSmkUs2XS3xCNZZ9
PeV3iC+gfe0BGiXH2nAx
=VOg4
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
