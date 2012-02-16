Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2BPUWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:22:22 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:46083 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab2BPUWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:22:20 -0500
Date: Thu, 16 Feb 2012 15:22:15 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V13] Add ioctl for KVM_KVMCLOCK_CTRL
Message-ID: <20120216202215.GA8090@mgebm.net>
References: <1329423541-11677-1-git-send-email-emunson@mgebm.net>
 <1329423541-11677-4-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <1329423541-11677-4-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Feb 2012, Eric B Munson wrote:

> Now that we have a flag that will tell the guest it was suspended, create=
 an
> interface for that communication using a KVM ioctl.
>=20
> Signed-off-by: Eric B Munson <emunson@mgebm.net>

Sorry, this is actually V14.



--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPWV3AAoJEKhG9nGc1bpJPjMP/0tuB/KPP8H0f3aytJGyn+ss
I2IciiVCBNufspjR0kDsSQHLx3OLgHdN3AZfcn3d1mTddzE1GJ0ZQjqv3/S9VUHa
K0JSxvYB5mHxeDGB8ynxXaevbigzPs4B0BCHIZzpsXBmkBT10RMa1vy/G68Ey30j
DxrUbDDHWBR1+n9+6pvQjjY3elXSRdIiJe9k+ATTAD4aEFkFxbBbARiee4srEtIh
Q2GEowEH2cYJWwcJGy7Xua86oRc+8lHLi3q/JvmdsbsiSjUxVX0L+gokgKoSFnmC
C7KKdPjdbZgBQ3YUA/Yj4KYdnirpHBHXW22zvaIJY3Y9NaqBrFybDLvplfqRkMLU
HfjNPLYvjIT4bJpv9GVb2+yw3komJcVZxaY2mePwBNt32RL9Sl0FFJtQY++3USrm
FdVzc5/u1lbZBssjw0fcJ4TPf3OX98+bsErU9EZBOVYoGOf67VMRxrxu2y8yLFKc
uHsQvDSqaqX9OfLA9NzePrHZxBh0CuddgH9tkRXu+GEL7+ZbnI/Z0uzS356o96wC
R9Djio3VNxOBaWNiKRrKvErD79ih0Ief5xshxd+xDGLIu+v5577NUc7VaaA7ZUco
vidqenqzoOkdzk227MwtRBQHDwPjbf1QQdr56QY8T7D++9eO7/ABsi+FxmYjiXvH
ZulFUBG1I3wkcp/CPDNP
=TV6U
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
