Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2HPNX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:23:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:64548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab2HPNXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="asc'?scan'208";a="202666619"
Message-ID: <1345123718.3393.235.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Genoud <richard.genoud@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 16:28:38 +0300
In-Reply-To: <20120816115713.726da8f2@pixies.home.jungo.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
	 <20120816115713.726da8f2@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-C+Dqd7NvvuNIwTsmb3Zc"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C+Dqd7NvvuNIwTsmb3Zc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 11:57 +0300, Shmulik Ladkani wrote:
>=20
> For the simplest systems (those having one ubi device) that need a
> limit
> *other* than the default (20 per 1024), they can simply set the config
> to their chosen value, as they were used to.
>=20
> With you approach, these system MUST pass the limit parameter via the
> ioctl / module-parameter.=20

Yeah, when you change the default, you usually need to do an extra step.
It does not feel too bad, and I would not keep additional configuration
option for a hypothetical user. If someone suffers, we can add an option
to change the default. But I'd start without it. So, I think it is OK to
remove this.


--=20
Best Regards,
Artem Bityutskiy

--=-C+Dqd7NvvuNIwTsmb3Zc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLPWGAAoJECmIfjd9wqK0GBAP/1dV3BhnwXtipZwe5IvGJMwT
DqduvAUExu635i2zhTauvftDwa4z+Bhefmy60XpY3SzVUknio6Rt4oakjAU8ywKL
08493jO90eJ7Z0hMf7HV9/TrHJh1g2ypJ2MW7LBPjaFmoch7PqB7KmYV4RS7INoA
67x/xXaifJHcU/lFvopxYa7GgVOCa+DUsC+PcBGL+1ZE9PzmslGP952bJ/quH9ps
d2oHlcasuoiuE2Fhx1V1AtJhUjSGnzzaCoHhh5BsJakcODboFOzukl6gWX3iB/LV
N7+m3TIqIP88gCqXIwyFQdUz8PmeD3N7xuIZi9mzmU6y4gSOxTJSVfzYph0yNNti
LWfnBoEev/LfbvEvNEdkMUaSy9hfA/3OvAc9d1LDgazch/xL9jnnatJJLklXov/7
LhHgrAkB0bWs3+CNY1bl+CzQkfJcR4q6kNQosk8fFHmfoahTyqkduuUZoXAvaajz
BMNtBoVc3zaZuESHv5yj2yEwQkw/dZyy1YrCAGg7t75/+/5IuaTwpVcpFAnHhTmH
z79t4YBlqoZfBdkYoyiZFtHFSqu/3la8AEa6Truvps93b26ljid7YW/SuvOuf4sT
jP/5g3pPUprIT/MZwQy4H518yvGCk4F//PplnyfUp2/TFW57LKbO9isZE81bnmmk
AdigokURDqjbT4xrwnUv
=q1D9
-----END PGP SIGNATURE-----

--=-C+Dqd7NvvuNIwTsmb3Zc--

