Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2JQNv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:51:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35911 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872Ab2JQNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:51:25 -0400
Date: Wed, 17 Oct 2012 22:51:17 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Porter <mporter@ti.com>
Cc: gururaja.hebbar@ti.com, Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH v2 0/2] Convert davinci ASoC to genalloc SRAM
Message-ID: <20121017135116.GU14199@opensource.wolfsonmicro.com>
References: <1349991229-32107-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ms5iOKSBOB9YS8zC"
Content-Disposition: inline
In-Reply-To: <1349991229-32107-1-git-send-email-mporter@ti.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ms5iOKSBOB9YS8zC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 11, 2012 at 05:33:47PM -0400, Matt Porter wrote:

> This series converts davinci ASoC to use genalloc and enables
> that support on DA850. It applies to mainline on top of the
> uio_pruss/genalloc series [1] which allows DaVinci to provide
> a gen_pool via pdata for driver use.

I tried to apply these patches but patch 2 doesn't apply against
v3.7-rc1 I guess due to the series you mention.  What's the plan for
merging that series?  It'd also be good to get Daniel's patch squashed
in.

--Ms5iOKSBOB9YS8zC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfrfLAAoJELSic+t+oim92FcP/17QX/ZIEFJK/0suszbLVCpg
12RdtEJLqMYrLNW8FjfK0TtITc25zTMWnK1vFR2M7zOyEuTdJVJhj7dyj+pWufaG
VRwipItbAG5XmEDvZx23e3NxNjMrs53Rnuxw9Z05m3oOBumIDSRUmT3a8SMPZtHy
y+4txK27HXMPF1d5WOsDlNK4PxhauCSfUqx2twAMn4oMAgD0wuwKcoGsW7oUkJ2m
EwbzJR2Msrew/yU0exXMww1qd7vxpc2O7Ch7f7+fAu1RAqbhSviuGqnQOxptztbJ
aEWZLLPWzZ9d6JbIqeTOdhE6f5d/0i3ctiVyhYiHr7pAE/+7XKQfZAXOzgIPe55a
K/SkFw/Hb0G6r92Vbtu1B8B8fbnFytnqVJA8JOmEj+5o2LJCCBgXWf+YEv2DS/Ib
4SsCiCtX82nbqEW1RRlrTmEz4BeOHKkSidiVTRrKBvTPOKaWeRkGKqhzXLkRKYsg
gLZZQrFYIcxmpL/OZanvIXMH9MTeaw9dqaizHkAT4PA37PJ6zbP5LxH6Gn/bhLRE
vWwKBsRWvTpxE49GIRpw5zPTV7rVrAluuJ3yhYjQ3XTh0WvmVnwJvcMOTMJI6/UZ
qAmpnU9cETZlgdAZQj7nBl3rno5721uSEgI1K/182Sbh46+wLEKOhsAmvVj6peBt
YCi17tmDdPFd2/aRPpMe
=2OxW
-----END PGP SIGNATURE-----

--Ms5iOKSBOB9YS8zC--
