Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564Ab2CMXSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:18:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48485 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab2CMXSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:18:06 -0400
Date: Tue, 13 Mar 2012 23:18:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix the logic of tps65910_get_mode
Message-ID: <20120313231803.GT3177@opensource.wolfsonmicro.com>
References: <1331594127.5392.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dQ2XShfnd5GHxhN7"
Content-Disposition: inline
In-Reply-To: <1331594127.5392.3.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dQ2XShfnd5GHxhN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 07:15:27AM +0800, Axel Lin wrote:
> We actually clear LDO_ST_ON_BIT for standby mode in tps65910_set_mode.
> Fix the logic in tps65910_get_mode.

Applied, thanks.

--dQ2XShfnd5GHxhN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9WlAAoJEBus8iNuMP3dHV8P/3I9wg+L0IRvf/FYZhoN3N6Q
xNpVGxfc2xje30Z/ppC08S484en8V8YbvBTYHcyho3FkHmkB7FYO+uGVaZr74xMu
4BMurR8jJB4hYHs5C+NzUfiDiR/UKVineaMj+oG1nRJsJqb8fFCLX93pixn6RkB1
IeX11Na2ptPNQHRQnBBwL7QM25Ajy3EiPNOdkVQL/ke2TT7Qp9vs4Qv3EZpetymA
3lbtrP4tYiqIm9zahwo0YnRDq8k5gK12IKf9ilY4JqrJAyZm1xLWHzA1QAfbY+LK
eFVKzkZ2+eYvJEs5MvtLVB6sH1fj86NhJ7u0MGx+TNIA0GFMJL9xSzXm6XAATjIS
crkxQPn9Ty/WxOtnnwm/w1/OVVhlKG2yD9XAxSIY9FJZ15yC51lWwPea4i6NY14E
nsuJpoYbgZqlrvkNACUYaF3qKI0J6Oaa6VibM88FyucrFEwOZtfSLkCm2WbDZ8e9
WnRmzxtIkKawMDjaDu/Zu0mEcNzTzMGQ5865h6dXdrE5QGk+tRx1bgyy837GqxIw
csmLVWTfZKy1baAVx5nhROw/gKWfsZmK1tOJ+F7gJ+H6BMByU0FYo3erRGgBtf3I
X4u1H+wL+WHWL5X2ubefUbi1cjHOhv1Aw+V3HDmJ58Bga3/zZeP/P5Su/vbmW2dY
43Eg+Tfrp4XV8F5WmkfA
=U4hh
-----END PGP SIGNATURE-----

--dQ2XShfnd5GHxhN7--
