Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2AYLjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:39:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40406 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267Ab2AYLjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:39:43 -0500
Date: Wed, 25 Jan 2012 11:39:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, lrg@ti.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH] regulator: Set apply_uV only when min and max voltages
 are defined
Message-ID: <20120125113940.GD3687@opensource.wolfsonmicro.com>
References: <1327483905-27007-1-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <1327483905-27007-1-git-send-email-k.lewandowsk@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2012 at 10:31:45AM +0100, Karol Lewandowski wrote:
> apply_uV is errornously set when regulator is instantiated from device
> tree, even when it doesn't contain any voltage constraints.

Applied, thanks.  But really

> -	if (constraints->min_uV == constraints->max_uV)
> +	if (min_uV && max_uV && constraints->min_uV == constraints->max_uV)

we only actually need to check one of min_uV and max_uV due to the
equality check.

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH+nmAAoJEBus8iNuMP3d3DsP/A4IURGaroMo6VOSZ4R10uBQ
JqAITy8uV8jNrwIy7ELsSjpo8OpS9UteZHv0vrQJarOKYiFQQadh59Oi/4iHYBRu
0rJGc0NLcYGhqmIRL3h/YF51VorrhkAfuiZmzm4/V5OtQi1Cgz4/SKUe6j+MavLz
x5UXJxn0JxfcYwoeZWUDeicpK9NEKX7BFqeHK+6n1lseg3u6lZP6vKDV/QaQ8OP2
glEs+/YWrvdOiFCJpHbuHYgl3RQePLALVzblJClWrZK2RzkZFRl2+hWWVUKLpOZ+
XyqjXWl/noFDR8/ZNP8cPpsTSAPqNm99wkVnUJTZG0UJeEEg5bGuXf4yKzPf4lWg
30Li0AW+qlKGLyQxTONOIj948uRLFYAEjWYuA2Qo0WZZ8ZCbzDY3jLQh1OpNOv0R
sUV/LZFkyZOwPh6MeE9HKEyNEv2FYAnRtzFxZaPBQdmrfpoCdcdCAtHEk2dUBFBa
UNXX7IQfA7pIeaznL/7IM4/ah39xd3ljETQYzFwLml8cUb9Ut7bj33SNnBBeGVaq
MROQIjB2E5AOSKK/M9wSsSmdojELYWoB7kBE0pa2p1qmKcBIr/OeBWblo4jbOysK
kaagra79MMxSfyCfgIMW9vc16/QR9PR//4tTMegvByQx7R9o2f97vfvZPOq1JfeX
qPVY/9rKvGlvfD2xrNzE
=J/0c
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
