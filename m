Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2A0UqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:46:00 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:41828 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab2A0Up4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:45:56 -0500
Date: Fri, 27 Jan 2012 15:45:54 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 V10] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20120127204554.GA5784@mgebm.net>
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1326825641-15765-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2012, Eric B Munson wrote:

> Changes from V9:
> Use kvm_for_each_vcpu to iterate online vcpu's
>=20
> Changes from V8:
> Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu
>=20
> Changes from V7:
> Define KVM_CAP_GUEST_PAUSED and support check
> Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED
>=20
> Changes from V6:
> Use __this_cpu_and when clearing the PVCLOCK_GUEST_STOPPED flag
>=20
> Changes from V5:
> Collapse generic check_and_clear_guest_stopped into patch 2
> Include check_and_clear_guest_stopped defintion to ia64, s390, and powerpc
> Change check_and_clear_guest_stopped to use __get_cpu_var instead of taki=
ng the
>  cpuid arg.
> Protect check_and_clear_guest_stopped declaration with CONFIG_KVM_CLOCK c=
heck
>=20
> Changes from V4:
> Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
> Add description of KVMCLOCK_GUEST_PAUSED ioctl to api.txt
>=20
> Changes from V3:
> Include CC's on patch 3
> Drop clear flag ioctl and have the watchdog clear the flag when it is res=
et
>=20
> Changes from V2:
> A new kvm functions defined in kvm_para.h, the only change to pvclock is =
the
> initial flag definition
>=20
> Changes from V1:
> (Thanks Marcelo)
> Host code has all been moved to arch/x86/kvm/x86.c
> KVM_PAUSE_GUEST was renamed to KVM_GUEST_PAUSED
>=20
> Eric B Munson (4):
>   Add flag to indicate that a vm was stopped by the host
>   Add functions to check if the host has stopped the vm
>   Add ioctl for KVMCLOCK_GUEST_STOPPED
>   Add check for suspended vm in softlockup detector
>=20
>  Documentation/virtual/kvm/api.txt   |   13 +++++++++++++
>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/kvm_para.h     |    8 ++++++++
>  arch/x86/include/asm/pvclock-abi.h  |    1 +
>  arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
>  arch/x86/kvm/x86.c                  |   25 +++++++++++++++++++++++++
>  include/asm-generic/kvm_para.h      |   14 ++++++++++++++
>  include/linux/kvm.h                 |    3 +++
>  kernel/watchdog.c                   |   12 ++++++++++++
>  11 files changed, 112 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/kvm_para.h
>=20

Just poking to make sure this set hasn't fallen through the cracks.

Eric

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIw0CAAoJEKhG9nGc1bpJAVoP/RhEZIRMAg1cuSaa2mJNtbvD
dbQBlgIfzE3xnGhru2iRkgycTwVzD4+2vxqcI2a+TI/lJb2PnhyusGWK33P+EHox
TcighNqCBLp6LmpDz+OvoKFHwcj/qWblIV1PjPxWZ56NadgADPzNkzjoOiu+0g6m
HOamLimQDakiS6feGB01+zjvCaUQcd4RmL7a/ybM6JRn46obAM0rZyMc5kn+AOM1
I0NscqFncf+NGe8hEZ+8nAn7sdx7C+5O8jOdqNDaDTWQky3IwLyAWmY2DCvuIdbP
O3fz2zyuJ895s/Lz6RNjfggtMnL80wAQiKxzwecLugT8BDdCqOCjt+4WvamsozEE
LKN//GuH2Oju9p8O66oZZ/Saw5Cmvc5NVCT06JvhfV268DsQ5o2ColwIFdJDFzbI
VcPXfWvda7Cl5DlQ5dOc7FjrPDltgqNeNUczlhyYKoYnCkhoZO128DYbIv+ftqde
joF1dOJXZFA2L7C+akvXYRruBdbeKpPWXPlOuKczNjxtO9kgJSAmud7Go58r1lFd
CQIdNEK1DXh0GZ0bchnNQPjUY9+aREcpsb92kAfTFpqI8XTWHOpOQiCzaEyfs08Q
DW4MvaNSxqY+MwBQ/F3A9BtumrdStLDsjeCJAs38MAOqzdX3xtf6yUAN7d89NmeA
0YITBpqF7jxn3OcuhD/q
=mtVO
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
