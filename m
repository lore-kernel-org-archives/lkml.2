Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2BNPuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:50:19 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:50192 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab2BNPuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:50:15 -0500
Date: Tue, 14 Feb 2012 10:50:13 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 V13] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20120214155013.GB6881@mgebm.net>
References: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
 <20120214152931.GA6881@mgebm.net>
 <20120214153836.GA21106@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <20120214153836.GA21106@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2012, Marcelo Tosatti wrote:

> On Tue, Feb 14, 2012 at 10:29:31AM -0500, Eric B Munson wrote:
> > On Wed, 08 Feb 2012, Eric B Munson wrote:
> >=20
> > >=20
> > > When a guest kernel is stopped by the host hypervisor it can look lik=
e a soft
> > > lockup to the guest kernel.  This false warning can mask later soft l=
ockup
> > > warnings which may be real.  This patch series adds a method for a ho=
st
> > > hypervisor to communicate to a guest kernel that it is being stopped.=
  The
> > > final patch in the series has the watchdog check this flag when it go=
es to
> > > issue a soft lockup warning and skip the warning if the guest knows i=
t was
> > > stopped.
> > >=20
> > > It was attempted to solve this in Qemu, but the side effects of savin=
g and
> > > restoring the clock and tsc for each vcpu put the wall clock of the g=
uest behind
> > > by the amount of time of the pause.  This forces a guest to have ntp =
running
> > > in order to keep the wall clock accurate.
> >=20
> > Avi,
> >=20
> > Is this set fit for merging or is there something else you want changed?
>=20
> Eric,
>=20
> On Message-ID: <20120210160536.GA23363@amt.cnet>, i asked:
>=20
> How is the stub getting included for other architectures again?
>=20

Marcelo,

Sorry, I put out V13 to answer that.  There is a stub in asm-generic that w=
as
lost in the V11-V12 rebase.  This stub has be included in the V13 set.

Eric

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOoK1AAoJEKhG9nGc1bpJCxgP/0rhC+n9kdlBLP6BPhgqKF8g
uNOElvU9NvnFixpb46zcX1ayIKDi02ecMNSstXGdZ+llG0CYZ7liblBz/uGXAA6o
q7QurcOMSrAeyJH5NgMxVp9fUEdYyog181FnVj77uagCIur2A8KZXEeuIqJCQd0J
5XDuuhBnbbfNkO5E2uqZOoyKVqz7rPTPAL7SDVFtGNl2S3IEAjX0JHgJ2xsIGbuL
J+c7krXyEbpQRwt6KfcU3lfWQBsBA24r/2XIoEr+6JkY2GcRl7e5Xi/NALkjWcfo
IG20s0rtnoAPC0MVytdbySlqv5VPx2A/Iiy62+I+KsFyeOWOTZh+qMornVXTFD71
5gSYqp7vyCPEZ3qa0RjZDspPXgqacwUmWEWeAuOqtndVX0EmRyBBVA9Nf74F48+n
TZhoQHjbFsflhobVZ5FmrpyuyOhet3lkK8oiwM0o0HWH51UJYOEGqsUA+oqLF563
y1qsztZso2i0jBnhrPOm8CuUO/v3fZipKOyISYu+2XUzR7u/kbt/2zZ7uxBlhLm0
IYoGEDBREDEzJa1zkuxWVrN1M+h1zWV9h/u7ZTOtPTdsEHDb9+15zNreOsNJE00t
mUJxOT0YfpjmGA5oyjxdzkDfoHKtwLCNTDR0H7AMvwVWQcCBbennwf7l+sWXDJde
ABMMrMS4UskV3WjhME9R
=jhq5
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
