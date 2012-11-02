Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab2KBSu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:50:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42636 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761234Ab2KBSu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:50:58 -0400
Date: Fri, 2 Nov 2012 18:50:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, swarren@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] mfd: tps65910: pass irq_domain when adding mfd
 sub devices
Message-ID: <20121102185055.GI4413@opensource.wolfsonmicro.com>
References: <1351877398-11389-1-git-send-email-ldewangan@nvidia.com>
 <1351877398-11389-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cTOVv4IlZiYEQ88H"
Content-Disposition: inline
In-Reply-To: <1351877398-11389-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cTOVv4IlZiYEQ88H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 02, 2012 at 10:59:58PM +0530, Laxman Dewangan wrote:
> When adding the sub device "tps65910-rtc", is it passed the
> IO resource IRQ for the interrupt number. This interrupt needs
> to map in the device irq domain. Pass the irq domain of device
> in mfd_add_devices() so that proper irq mapping can be done when
> adding the sub device RTC.

Rewiewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--cTOVv4IlZiYEQ88H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQlBYIAAoJELSic+t+oim9gvoP/A9DFk52WqHs6VszLbGRvVLD
C+k3eiitikxqAViF+eoKdJRq3lFYVayOrK2CaT7S/PQ7oIHvPz992n+aETBcBxx+
l8OyQfxROLeXO+Rn7p7KdTQQB218OGqYChK3Of/Mx+Gd97eWyPY+Vg8x+uf5eM07
ulJc7jvANtu34ij4mdMbRh4B8i8TF8xKdYBtxM/PugrwbDk+YHxGgphHtL4GjUxA
PRSFgCapFk/bB3oFz7ZWSJR4RaAh+2xxU9M6uxZqoX3TFdLswlL3d+Fate3p3pNL
uqoRLam+DzsX+NhsV8MVHiGPxKZlW655xNRZ0EyYWS0Gxs8bReQ/i9pvUzO509RC
NM2wWMZkRfxJKIQH+nVx8zGVwdtISYcd+hpHWjV4TB2cbksb6Vk/q0SckIr4Oixy
fH+kJK11j115MijNl5E4vcaH35zzsEA5Tce+EK/hwT73/fcrYJva2cNSvqWTpz3g
Ku/tQS3YCb2puYje8cOysDPOii1Z9iZKhqqmrHJuJnGDiYhQc5vnoi6dWO6lm2UJ
RbA9nH1tbbgJ/z85S29B4ldAT2cch7X/ge7vUR+5VyRqTo4waYzj/j2dJJoP6PGk
fZx3txFMTAPaxy3/bBYQapkYEBsVj/9bANb4T8FZBF/bEJLjwcWlNTlMEp5Nl6F0
Y0LoIzoQZJwShfLU0yW0
=YrKC
-----END PGP SIGNATURE-----

--cTOVv4IlZiYEQ88H--
