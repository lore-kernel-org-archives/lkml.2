Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2EGOY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:24:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40042 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756138Ab2EGOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:24:56 -0400
Date: Mon, 7 May 2012 15:24:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] regulator: tps62360: enable register cache
Message-ID: <20120507142453.GG17002@opensource.wolfsonmicro.com>
References: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com>
 <1336394306-2211-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <1336394306-2211-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 06:08:25PM +0530, Laxman Dewangan wrote:
> Enable cache of device register using regmap cache RBTREE.

Applied both, thanks.

> Just resending as part of this series.

You did fix the thing with the defaults.

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp9spAAoJEBus8iNuMP3dcjMP+QH9K0WYGdWVkqu1rjDtgabj
nYDaIbG9jC6LpxMCz3sbmQ1hVmcLvdrLT743X4x7ERnqBUIQq2CSdD/BkO5E9Xzr
iLG3EDX6OJtw/Yi3vJf7E2kPeXIZP0TsAO0xhzFNMr/xwHbb+HhsQQdW3UJn9/y6
1mU39uJKmCTntMNZja4MjlA9jmli3UTF7OTGKhjHAk/m1sxTix7irDx6N25Xxr+y
/IEx2UX75VON0xDQ/ATHhxxr5sci1VaTQfhHk0W5nTnBwxXuwVhsYB7PnCP2YFhL
RdSlZVHIWiXF9ZIA0iaA0NLXPSdqCw2SZ1vggicT2q5Mk8PhSSscJmFAdwbB3hPG
I3OQACIAm1k754/0hifKUD0cMpyJNCCJFqyIYvPPBqIFeJ7SbB6ZPsVO/frKpmcZ
5/UOHPb+ijDbbeNlrohArya3zHyRdjsmVIUqpTwoUCUCVrNoCBVpmrwzZgQ4+G2B
MPa9qaBg+WjV4SHvvw23ITJXDnXfUq2/gnbZHwIA6pfO3EEv0LpTNtZqVazHhEZb
mGSyIehawou7gi2dm2aSX/8WhlqaHyhDBEzEVn+e9psDYnFtVQ2UEhOn8VprUCjQ
EOd45asHQ3Yj3QdAaJ8FStS0mnqJE0z+a8Obj70obr1Qz4GqeDrivas0q6nHEXMd
8FX2yFXZ1g1NWT9ZbboM
=GOUF
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
