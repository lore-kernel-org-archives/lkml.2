Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161447Ab2GLRUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:20:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51188 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161288Ab2GLRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:20:28 -0400
Date: Thu, 12 Jul 2012 18:20:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add REGULATOR_STATUS_UNDEFINED.
Message-ID: <20120712172024.GN7256@opensource.wolfsonmicro.com>
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
 <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
 <20120711132655.GG3938@opensource.wolfsonmicro.com>
 <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
 <201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
 <20120711174257.GN3938@opensource.wolfsonmicro.com>
 <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
 <201207121255.q6CCtdE6028265@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
Content-Disposition: inline
In-Reply-To: <201207121255.q6CCtdE6028265@sw-eng-lt-dc-vm2>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IuJpT0rwbUevm2bB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 12, 2012 at 01:53:35PM +0100, Krystian Garbaciak wrote:
> REGULATOR_STATUS_UNDEFINED is to be returned by regulator, if any other state
> doesn't really apply.

Applied, thanks.

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/wdHAAoJEBus8iNuMP3d/QkP/2gpm52tchpEtCqRZT+vKxwv
wrP2Yi1HsyhSHR5bmiaFI9uwD3Lks9DRsQ8GK2qTF3AP0xuXt8FraaneXtAvnJnQ
aifH4ArAD0v5Mj6s2Is//5nO7s6JcYjHu07zoc5aw4xzjr3NTYjT8pRWRLAcBVGw
/c5wSzy2Ira7qinHXqlz+pb3yfeDDbCxjcmy2HaZTC4Vb5vzqQV9sK325hf9tZAW
o3Fp4xGWSTplEPRXbzjx6IpjQSFZby/NjLvu1lHusLP6h1a7N8XvXTxnKcOQxNZj
agVEnVHKjsLGqhgnA/LQ0yGOleaZWrbdv4rFZdSuxcwwuzkg3rrHwfCYwVA5cX+C
kQadW4VWY5Nf08jzkwr7C8IknXRQQmg29Ol2o65g2Zg/oIumnoND188MkEhl25D6
gyXWGlGXPSR+ZGANAxD4skytkqcuDZYTNxo/SbPYgWuLqudCSeoDexinWQiRwByh
wYJaZvuPC1P04VuoyHo6hURlosEm1bNerKgUWT4m66tRVlG1u91QBxJ3K04/ToAY
KP2coXgibBcdNVZt1BoXtBJ6glGpg3j6ZMx9cHuF/6yi/02jzi0RzRiM6n/xGOMb
32QNACvxEjwJv6THU93PrPD4if0jfqWX+YO7OAGrqJzznoMUXNJZZWSAYDj5Nt7Q
DFUdtPyJt6BtNQwgrgFM
=DmU9
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
