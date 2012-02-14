Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241Ab2BNVRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:17:25 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:37354 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761223Ab2BNVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:17:22 -0500
Date: Tue, 14 Feb 2012 16:17:20 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 V13] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20120214211720.GC6881@mgebm.net>
References: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
 <20120214152931.GA6881@mgebm.net>
 <20120214153836.GA21106@amt.cnet>
 <20120214155013.GB6881@mgebm.net>
 <20120214161009.GA21515@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20120214161009.GA21515@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2012, Marcelo Tosatti wrote:

> On Tue, Feb 14, 2012 at 10:50:13AM -0500, Eric B Munson wrote:
> > On Tue, 14 Feb 2012, Marcelo Tosatti wrote:
> >=20
> > > On Tue, Feb 14, 2012 at 10:29:31AM -0500, Eric B Munson wrote:
> > > > On Wed, 08 Feb 2012, Eric B Munson wrote:
> > > >=20
> > > > >=20
> > > > > When a guest kernel is stopped by the host hypervisor it can look=
 like a soft
> > > > > lockup to the guest kernel.  This false warning can mask later so=
ft lockup
> > > > > warnings which may be real.  This patch series adds a method for =
a host
> > > > > hypervisor to communicate to a guest kernel that it is being stop=
ped.  The
> > > > > final patch in the series has the watchdog check this flag when i=
t goes to
> > > > > issue a soft lockup warning and skip the warning if the guest kno=
ws it was
> > > > > stopped.
> > > > >=20
> > > > > It was attempted to solve this in Qemu, but the side effects of s=
aving and
> > > > > restoring the clock and tsc for each vcpu put the wall clock of t=
he guest behind
> > > > > by the amount of time of the pause.  This forces a guest to have =
ntp running
> > > > > in order to keep the wall clock accurate.
> > > >=20
> > > > Avi,
> > > >=20
> > > > Is this set fit for merging or is there something else you want cha=
nged?
> > >=20
> > > Eric,
> > >=20
> > > On Message-ID: <20120210160536.GA23363@amt.cnet>, i asked:
> > >=20
> > > How is the stub getting included for other architectures again?
> > >=20
> >=20
> > Marcelo,
> >=20
> > Sorry, I put out V13 to answer that.  There is a stub in asm-generic th=
at was
> > lost in the V11-V12 rebase.  This stub has be included in the V13 set.
> >=20
> > Eric
>=20
> Eric,=20
>=20
> I know the stub has been included in the series. But i am asking how=20
> it is #include'ed for other architectures? (can't see that).

Marcelo,

kernel/watchdog.c now includes linux/kvm_para.h which includes asm/kvm_para=
=2Eh.
The check_and_clear function is defined in arch include/asm/kvm_para.h or in
asm-generic/kvm_para.h for any arch lacking the specific header in their asm
include dir.  If I have misunderstood how these headers work, please let me
know and I will fix it.

Eric

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOs9gAAoJEKhG9nGc1bpJN50P/3o6c0GrXC2Xn653CeG74J6i
BZc6rsJgVQVQWiFdlb0pMWy8l1m18QgJGY2zYxB04Sr5U/Hv7Gb3g+08fVYqJkAM
RGlFGjZSLNPfQ4huyGnkWyY92hMf1x6YcmqWwcXR30mpkugJ3ARDL00DGyR06WE9
9BzijOQr3Xn3wUMtMY3sDzj4KwnZduBYVh2zCxaGouUs5gtlMsDAgKt69Ye6gMtR
CY6wDwFm3cS/XsPBekxqr7ZumrMVD5hV5NkmlpT4xexHtca2PfWoojfEVSHnDR7W
yqjszhtS4rcMyr7u9i+j3StI6joB3EjOkYrHFMKPP4/3kL9tfymXk3EedTdulTu0
730Dxxxes6DILE1ZjZfdp1NpVgayGIx3Uu6yB6EnHQ+mcnQCjfAFKOs31K5B7eHq
ioIxTBOKOs3/blHSEK4li05oGR7iGa7yOHrx35sh/YevZtOYW1kapJJ1DrCGUnIu
xwBlQmPwppAU6xVl5AqruWyJnCDXhSk13+ZO/A4OZjb/uHBkeBG7R1KrbSrTYv1m
VlfffMhbqEKrsAqMxI5RQBZyqC+jRr8pCZI3IONi/ULFGtZwnA4PyEyfSthSi+wW
8d/Jjnfr6Rc2Buu654E59D7SsYo3XYntwSMx/0RF/U7tIbwoxt6k15oZM9sl0Phb
IQsVK0/fsmptlR+oE6FK
=XueJ
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
