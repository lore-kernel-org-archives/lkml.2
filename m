Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2IKKqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:46:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2IKKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:46:53 -0400
Date: Tue, 11 Sep 2012 12:46:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Xin Xie <xxie@nvidia.com>, "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "jhovold@gmail.com" <jhovold@gmail.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] mfd: dt: add power off support for Tegra20/Tegra30
Message-ID: <20120911104635.GB28904@avionic-0098.mockup.avionic-design.de>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
 <A7051F87A141B744BCAF487D48E5B3BDF5BBE83B1A@HKMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <A7051F87A141B744BCAF487D48E5B3BDF5BBE83B1A@HKMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lrHpN4mWGItTYgE9Xeg1cS2Eae05+SJueGoy+PDdwR3
 mAvQezokMMPpRsMJc+DgIIS7LjjqrwwzH5/NnPY2N/AHLWZ6It
 +Qxgl/SwiKIXPllvXfcT3DNcAra5MEfKGWsQ1qubJPC6FrwzTE
 98SiXF39ByVwwLoF3ARpcDEKK8EFXkUSUJD8H0mVbj0LKaNYto
 OBwsgGkm/SRZMILxH2K25ISLjsKQo78otxJEWWed/y+S4YS5Kg
 Dgwrk3XhrUG4OoD3/saaPRNadcBg4kGwawycSiwPfRXWU/HIGv
 H9oJnHaOWuUQqPdRCSHx2vw3YYXNpsG4UtNmd/zR1L7lDiFBlO
 dAHiSF+R7yKdHMjNVj41tLem/R9IAIwEjHgNKeSgV//Q6UvJtH
 Bv7GP4i87gZCCAXa+8F/XN7mZwsge4qnJE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 06:25:14PM +0800, Bill Huang wrote:
> Hi all,=20
>=20
> Could somebody review this?

Given that I haven't been able to test yet (due to time constraints)
with PM_SLEEP_SMP enabled, I don't want to give you a Tested-by, but the
code looks okay to me, so for both patches:

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQTxaLAAoJEN0jrNd/PrOhMrAP/3TFBm/FzXFsRyBM/mz16nQN
dVHPyIUTpkCt5sJW9/c+WDkJFOsx0yYrIIV9GsGxXFsPMn766svA8IFmihZmYrSG
ckWJovr+fEcOCOqsddAQ/GgW16WrVrshkSDPJFrlWzszvt6PdAQQkY9h+FgZXHE4
qDKFgpStkjmBahzyEG0BZrBexcvCq/X/QOfgSQpvl17rqnWdSBmxzVWEfODYveOW
zkjJ/Q7SYlaO58ncuDrp0ERRePzfbgZkHZSyp62BqRbQZ5QvGAdLWaDqTnwnTvmL
4MuD1VpqCOo2hbtVfpuKM7HspVUvWwbUMFQvrhxAOaHoDkdqj8F2reCEeLF5paCI
T6pZ1R6Lpuy7aRyHQI19NO2dLvAp9hDK1saHGE9S5YXRyq9qXnxso73kpaVGxacw
kj8/y7avVGBO8VxUXHm4S0dSGFKFW9uMVf8Nej45C6ujPrdqPDaa8qjK8jXc4Iq6
Tw7bQNY14w6k/IVC6IR78WjvVSEO+08762C9kkube2dUy0lWXYlH0R7ffSWAHIH8
bFDHhVUhWk1jL0evIIHiLRhyu10VpRSOyMU3xlCRGt1Rpwxy7CcVHmfwAZaF39BP
WFFNIHoAE9ZTdzJ8veh8X4mZWxHkCXanh03gbEK9xGmYi5Kz9vjBhSKCK63/4vfF
D/hzEKEzf8Vlu5reNX4U
=Bn20
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
