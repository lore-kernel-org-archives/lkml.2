Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab2C2MGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:06:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759223Ab2C2MFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:05:30 -0400
Date: Thu, 29 Mar 2012 13:05:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, lrg@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Board breakage due to upstream patch
Message-ID: <20120329120526.GN3668@opensource.wolfsonmicro.com>
References: <4F7430C7.6060505@linaro.org>
 <20120329110424.GD3668@opensource.wolfsonmicro.com>
 <4F744D3B.3030605@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jnYfR+Q8IWTs8BNa"
Content-Disposition: inline
In-Reply-To: <4F744D3B.3030605@linaro.org>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jnYfR+Q8IWTs8BNa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 12:53:31PM +0100, Lee Jones wrote:

> I haven't undertaken any debugging of the issue, as I don't have the
> time, nor do I have the knowledge to be able to tell you what might be
> happening as a result of the change.

> All I can tell you at this stage is that with your patch applied, my
> board doesn't boot past "Uncompressing Linux... done, booting the
> kernel..". Once reverted it boots again.

Like I say I would expect that the board had some breakage in the first
place - look for errors in the boot log for example.

--jnYfR+Q8IWTs8BNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdE/+AAoJEBus8iNuMP3dOU4P/iisAStgoif/9LsZNsSZ53ET
FBwEa6Lyotkx5ajrYZEq2jo42nX2uqcZalKGEDaaVccX1YGCJOX0nNRzy3Llt/1E
NFlpv859KJWzG86SgNCfm2nWU5706SBaLJ1mmilwibIcn1dZNkGyZQvPDdAuWCI4
7uZ4P//QNBMIXVNuM++OrwYC3nShaSNXypFcr+pc7ZWju2vPNJLxoRF5r0abAiUK
rsWB1bjHd5SvEg9G0L28nlzfWbT3yRNJMFAE4VndsP6g8SoheiOGf9WwN4mDXjxL
VtbOxJZ4MHQgX+oh2XU4ck3KOp+eYX53aKoRW6AFAxi2rdN3d18khMdVJ1qBR03Y
qJQYvwuA1l3t0fnGJo2WVK4kbC3uUT/XORIV+1xMe+ZEoG6GOnRupE0stvdQ94Gd
pjnBz3KnGEavJk7eD1xDbZIsBBmEonlMlZEqzcLArkxjdML6QRIdfQaEF3ygHoE8
laqe8PlAwsfZfW0ha6wTw3llDX+lNBTrRMSQ3+ftjd/Z8kLXwIrbzIIfVxoSGGcU
5Fsih9TKpdBugc/P9hKpA0REQ9D2hSk9wbJSQgaIkW6IItAzKou5z5puiN/Am1ge
SYxm53cqRS/5lWr2iKXQRmqE15FCzHsuQKFOSW2fDiiGV1LrYDSNunWRb2BoaJcq
xwPmEBNVdl5qTVrdLlju
=Uue/
-----END PGP SIGNATURE-----

--jnYfR+Q8IWTs8BNa--
