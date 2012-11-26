Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2KZOqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:46:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58461 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab2KZOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:46:07 -0500
Date: Mon, 26 Nov 2012 14:46:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] regulator: add device tree support for max8997
Message-ID: <20121126144603.GL9411@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
 <1353657795-1725-4-git-send-email-thomas.abraham@linaro.org>
 <20121124175954.GI4719@opensource.wolfsonmicro.com>
 <CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
 <20121126095141.GC9411@opensource.wolfsonmicro.com>
 <CAJuYYwTt+1-zU3092GmrK2GHR=5QDGT-diVcm_0pe3=oqhuQdA@mail.gmail.com>
 <20121126141108.GK9411@opensource.wolfsonmicro.com>
 <CAJuYYwRRauS54nt3QxyofqSyKGcJ+T_9tnjGSt60LtGOnP+ccA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3xQkynibq3FKlJyM"
Content-Disposition: inline
In-Reply-To: <CAJuYYwRRauS54nt3QxyofqSyKGcJ+T_9tnjGSt60LtGOnP+ccA@mail.gmail.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3xQkynibq3FKlJyM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 26, 2012 at 08:13:23PM +0530, Thomas Abraham wrote:

> I tried applying this patch on the max8997 branch in your regulator
> tree. But this patch does not apply cleanly on that branch because
> commits "5eb9f2b96381" (regulator: remove use of __devexit_p),
> "a5023574d120" (regulator: remove use of __devinit) and "8dc995f56ef7"
> (regulator: remove use of __devexit) are not available on this branch
> but these commits are already in your for-next branch.

> I am not sure if it is of any help in rebasing this patch to the
> existing max8997 branch. If you could suggest on how I could prepare
> this patch so that applies cleanly for you, I could do that.

Send something against the topic branch.

--3xQkynibq3FKlJyM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQs4A5AAoJELSic+t+oim9eJUP/02sHdz6EVF5ATwoaPNfHTTi
OGAq3Aj3cJxHtIEaKEKPs3mlh+eZrs6PsTdz98Sq6h8RgeRiC+grW5gwieLBDFOQ
jnKte1OnnufLsDZ3FUHM+LQnPTOvarS7SEXDwfty1kZlOGaBEYcFzArLHf7x4ZqB
n9STQ45DProcWlPOkspTTL752Y3C71drYGHT6MaYjkE7nMed2sIMaFMYp1dF+GC3
hFcWQb+ztXvR/KAenowhECehDQFIwd09bJmrVljCylTdoCXmvviO/Yr5RCQ7wy0d
Q+BVsTBIpQpJilRXyk5zZfb1ptTM5nik9Hv8+Qc5i/bGV67aGW2iU51q6SvC7umi
ns+TDYGRY5pmocRzAZv6LLZXFYEPsuqhJfyg/iaqNM4rNiiuMqQZ3UH/624ISKKJ
9Gf1ugGdITfNbZoEVwWdm1Eb5jiXbDkQYGKLhOrn/EwVJAIQIWhKAGThu093nuXX
kr0W9nAm3b7+0W4Zx2MQccMq+RxHXHAm8V9541ziUOAG8BjNj/KuIRvAAfzenw4O
vd5C2uahpzzC85In5BxdRkzern6UCZVqJr3nat0E3AlMcmil+6jCPCw8eLId+zWC
2ANtwfUbeepTzOons15fhQohlbmOXKi456p0Wh/4dcsjcbJolWNW7zzeyPRJS4Sn
MYIXPBQ4qPMOB2Jua1R9
=KUAP
-----END PGP SIGNATURE-----

--3xQkynibq3FKlJyM--
