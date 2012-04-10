Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2DJJIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:08:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42243 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab2DJJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:08:11 -0400
Date: Tue, 10 Apr 2012 10:08:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RESEND 1/3] regulator: Rework s5m8767_set_voltage to
 support both LDOs and BUCKs
Message-ID: <20120410090807.GA7499@opensource.wolfsonmicro.com>
References: <1334037944.15859.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1334037944.15859.8.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 02:05:44PM +0800, Axel Lin wrote:
> s5m8767_set_voltage not only implement set_voltage callbacks for LDOs,
> but also for BUCKs when s5m8767->buck_gpioindex is not set.
> s5m8767_set_voltage_buck actually only for buck[2|3|4] when
> s5m8767->buck_gpioindex is set.

Applied all, but please don't resend things like this where I've said
I'm waiting for something to happen - I'll have the patches queued up
waiting for whatever the event is.

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPg/huAAoJEBus8iNuMP3df4UP+wVq41QE7joNI3esYFpuVUg9
9hlg8jaKEHaWE80bgexte5ID4YlIKXVy48bYpUnUXabIdnEFl+1kd2tTSNrQPgtG
qu/82V5eg9ZtUBje25EcsIjqOE/ZLg2H67Ok5ai1u+x/tJofNcT51nV8ZB31yrTF
bcdqFK9GGZ9uXc7LUsLKf/M9anTbXNxxI4tYo90GMbqvhSQOjbZnxWubRFUsltTZ
p+mX4IehKtcmPMOKZZI/9Zs/nrrxjV2SpbVKOvXVbBqVo5gLllIEwxEET3k+IdMT
LE/XPChJ6bKm87eJrMpS/GLS2M4K7vKc5plKL7AtwqgnoJw4QdqOoaHAGeHjy7lD
7BFaBcXBOeexO571bIRRBWEL/FZJPlhrvQNTSVv5g3c+K/9m4vbgFqv0WO6RRKrN
KY2R3Q8V1fkpk119FBY36CnO3iU96GzJwv1os1w2kQxoP1eR8GYfCLOLD3f/U8PR
e9qw0tbz6V5cRf9JrFx64lm+c8TZjlCjCNkdVuR4uX4i+pPXZxQC50rb17s5VyQi
2OPigURPmSoapdmW9fvdtTCawuKeXr+ZRPesVAW8pNuQNRaFZ0IYb9vXCK8V+8m9
3SLrYghYgH3VJZQdrc099Tny2N2Zohp7y7WBWqjhqoVCb5vD4gs+yk878qOfZjyP
EkG58Me3E6Zhg5ys7eKd
=ktYZ
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
