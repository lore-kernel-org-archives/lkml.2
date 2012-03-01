Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059Ab2CALLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:11:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714Ab2CALLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:11:05 -0500
Date: Thu, 1 Mar 2012 11:10:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: Kill max8997_get_rid function
Message-ID: <20120301111056.GB3124@opensource.wolfsonmicro.com>
References: <1330565187.5373.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <1330565187.5373.1.camel@phoenix>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 01, 2012 at 09:26:27AM +0800, Axel Lin wrote:
> Use rdev_get_id() directly.

Applied both, thanks.

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT1jTAAoJEBus8iNuMP3dfk8P/jt7JL3+xUU1Giz6sUBOkWGP
iT2TZzRZbpR2l0wZPTdMFkzCo5p5e1Mm+7KdchYjLW5Kh9OngZ4AkGc8NOeYeIYM
W+W1udqroAo6BsFYPkrbGqNQmEAqS5VoEsY+nNyIFmxSQnzO/5XwRXT0nUKy7uRN
I8EKgjwVGNNBxIloR4zGgwKAZNZ3Q2zea74/lMoh2zocZdxrefw+SQfNmeHson9X
7QuA+Diwf0k/JJr02Wg4FkQKJsT5K2qq4M2GHd0G435e+rkcuO/4kAin4fJDrexE
P7UxQ52Z/Zzwvi76Q+D3kOnfutKJYqUs1WImSa1MYPsxRrqT8YUg1hssqwNP9rix
cCD9aPQV8w/pRfnwBqI5EuZGdr4RjjUtuT4vgQb0Mcy32bM7ZLcO2XorWdaXtksb
g1/dvvJHRwH+MyG8E7OLLftTa8kKgpYgx+fuYw5JVymaU5Ja8f57HVnfgam1EHTn
TjP0jswiV781vy2pjLOv1mSD3LMN8cEJxaUbMDyjyW+6GarkBI1zprStVz4FWhTp
Ni0MmlF4nmRguGQc4PqKtRn3ZCVTlEX/L8aj3bXTMhiBuKbpUs1ePU+ZYWPuM+As
/WoLwmjCc6mZy42KowUma6CsZcduJtJ43bTjr9t2bHtZoogRhMLIshOt2m70w8Nk
O3kWKdEzhglJogQot1Wy
=WZq0
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
