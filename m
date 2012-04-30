Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2D3W3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:29:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45543 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756795Ab2D3W3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:29:19 -0400
Date: Mon, 30 Apr 2012 23:29:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Anthony.Olech@diasemi.com
Subject: Re: [PATCH] Regmap: Converts group operation into single read write
 operations
Message-ID: <20120430222916.GA5604@opensource.wolfsonmicro.com>
References: <1335767746.9546.15.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1335767746.9546.15.camel@dhruva>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 30, 2012 at 12:05:46PM +0530, Ashish Jangam wrote:
> Some devices does not support bulk read and write operations, for them
> we have series of single write and read operations.

Applied, though please in future

 - Use a changelog that matches the subsystem
 - Follow the kernel coding style, you should use

I fixed both these things up, and also...

> +	if (config->use_single_rw)
> +		map->use_single_rw = config->use_single_rw;

There's no need to check if the flag is set here, you can just assign
directly.

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnxI2AAoJEBus8iNuMP3d8wMP/ivSWKFKalHyK341A/bJfFRX
nYCCc0Sb916dwi1DkW6YXOGtd7Ww/sWYHmnxy+A40D62JS/ACZ+gfSnp9Dl2+s+v
syBg95IpDIEBIUDySbfmiWUBjx+ZgNUZUVYYfD1kFhUcEAeQ0U5VnduBqOyKpEu6
+XUmlK+rEDWEdeuob/doHAXIo2D/78jic1SeXUG5YlJrOOBnhXXhZFKQREcwO81g
884GPsRM6AILD89DxkoPY+ovq6PnJOyvznTivxoeIPAUsJE4yZk5PcwNdvnWCUWM
jyQThHquJjQi0NXo9zlgiglHZb0/k3OrwyXH+G1TMOj9di1rJJIwI6Hk8do8Ukcr
HuJFDiNx67La8MGduJJ4xM8rc85ddQn8RX7akixtr+FI4j9UT+4T76ExsXi5sYdd
wjm4LX33HfrL168ks0IEKUaFXzcDTL9pEYjFNlcyJLBtjxHdBK5qeJ49EJ8cYRQB
T1aJIWr9m7tANKVleIVH7aQgwZja1HXvobxjjZySNEEYwzFPUsrymocOlUWVm0B+
9MURXuSbdih6QYKAGEB16xepLjfr/t3paOmV6FLG2qrdfsGeTvJU/rHGp6BNZ0lp
jvp9TpP/idl49w0+LAYl5JYKQgXQDTw4UOxo7kShfROCkWq8QoKTEojeJYH40woC
7M9pQ4VG4gpn/EHPe3nK
=mpFQ
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
