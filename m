Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2BNP3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:29:41 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:50075 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab2BNP3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:29:37 -0500
Date: Tue, 14 Feb 2012 10:29:31 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 V13] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20120214152931.GA6881@mgebm.net>
References: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Feb 2012, Eric B Munson wrote:

>=20
> When a guest kernel is stopped by the host hypervisor it can look like a =
soft
> lockup to the guest kernel.  This false warning can mask later soft lockup
> warnings which may be real.  This patch series adds a method for a host
> hypervisor to communicate to a guest kernel that it is being stopped.  The
> final patch in the series has the watchdog check this flag when it goes to
> issue a soft lockup warning and skip the warning if the guest knows it was
> stopped.
>=20
> It was attempted to solve this in Qemu, but the side effects of saving and
> restoring the clock and tsc for each vcpu put the wall clock of the guest=
 behind
> by the amount of time of the pause.  This forces a guest to have ntp runn=
ing
> in order to keep the wall clock accurate.

Avi,

Is this set fit for merging or is there something else you want changed?

Eric

>=20
> Cc: mingo@redhat.com
> Cc: hpa@zytor.com
> Cc: ryanh@linux.vnet.ibm.com
> Cc: aliguori@us.ibm.com
> Cc: mtosatti@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
>=20
> Eric B Munson (4):
>   Add flag to indicate that a vm was stopped by the host
>   Add functions to check if the host has stopped the vm
>   Add ioctl for KVM_KVMCLOCK_CTRL
>   Add check for suspended vm in softlockup detector
>=20
>  Documentation/virtual/kvm/api.txt   |   13 +++++++++++++
>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/kvm_para.h     |    8 ++++++++
>  arch/x86/include/asm/pvclock-abi.h  |    1 +
>  arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
>  arch/x86/kvm/x86.c                  |   22 ++++++++++++++++++++++
>  include/asm-generic/kvm_para.h      |   14 ++++++++++++++
>  include/linux/kvm.h                 |    3 +++
>  kernel/watchdog.c                   |   12 ++++++++++++
>  11 files changed, 109 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/kvm_para.h
>=20
> --=20
> 1.7.5.4
>=20

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOn3bAAoJEKhG9nGc1bpJmz4P+wfFlf1MEADJJJQnQJ1bXbKN
sd7h2GXmaP5XGXrnLjdBgIVzarrCmLa37taUI33Zb1T/6U7oF5diE0q0zs7AF542
bllo7iymWQOo0ccKUZdBqkbi0O9g44NQrjRtf3eIviVGqq1C8X/2fOw6Re/DQyS4
vNUEMMeKfAitaNvY0klLzm9eDH/f4ylsz3lMPkkjfPuJ+hghUuALefmSZvAajzmJ
eQeL7I/Porev1vSf3SUHoTcb/uYWZRlPOHDM9sHY/VJYJiGGXbShvKqygZq0w7n8
6EUwmARoVwTytZDdtITTvhyU2Qa7GpneDSipxcsgCt/N5ODv2lFKMJMC+7a16i7y
gufMZKzBrRWJTcSZ4fBtTYzA2QYtmARnpKNGMW5xPVBeKLYFPmnuBYLEy5qWK4jw
4jlPVqpP0DMtPSB4dx+1EXAoUsszdlfPkgVi9cSIS4QXOpT5cPV5cgU+UWGB4dUD
qGQFn2sprwsJeLqnYpmxXeq49m0y+wGRuywsp3hPPAnalsM6jjJQrqmNT3I7g0ra
fDCfODyALxohC1psUcRuWy8vAc1JLa/ayYzNpBPmeTjpWp2ie4gzC2/vKMbZ7d2i
TTPKNoz8e3mlzulwN1gB0hefXTeNJGoXb8Mw9QeuDT/efX7gLxXSZT4FvwfNRv9s
c1OMpLHixW5QtImDscoF
=4uHs
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
