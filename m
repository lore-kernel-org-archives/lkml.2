Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab1I3Udr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:33:47 -0400
Received: from 74-92-214-37-Colorado.hfc.comcastbusiness.net ([74.92.214.37]:36493
	"EHLO zlynx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1I3Udp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:33:45 -0400
Subject: Re: Samsung Series 9 seems to require acpi=nonvs to resume properly
From: Zan Lynx <zlynx@acm.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 30 Sep 2011 14:34:46 -0600
In-Reply-To: <201109302222.22528.rjw@sisk.pl>
References: <1317329529.3151.10.camel@knife> <1317413360.2629.2.camel@knife>
	 <201109302222.22528.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iz8r/8tDVCwGHsPvJIp7"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1317414897.2629.5.camel@knife>
Mime-Version: 1.0
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20110930/1R9jmA-0006Pd-4S-linux-kernel@vger.kernel.org:zlynx@acm.org:74.92.214.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iz8r/8tDVCwGHsPvJIp7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-09-30 at 22:22 +0200, Rafael J. Wysocki wrote:
> On Friday, September 30, 2011, Zan Lynx wrote:
> > On Thu, 2011-09-29 at 14:51 -0600, Zan Lynx wrote:
> > > After being annoyed that the latest Fedora 2.6.40 (aka 3.0 something)
> > > kernels would not suspend/resume on my laptop I followed a Ubuntu for=
um
> > > suggestion to use acpi=3Dnonvs. This worked, or at least it is workin=
g
> > > today with Fedora 15's 2.6.40.4-5.fc15.x86_64.
> > >=20
> > > The system is also booting via UEFI if that makes any difference.
> > >=20
> > > I understand that there is a no-NVS blacklist in the kernel. Should t=
he
> > > Samsung Series 9 be added to this list? Or could it be a different
> > > suspend/resume problem entirely?
> >=20
> > Please ignore this about nonvs. nonvs has nothing to do with the
> > suspend/resume problem on this laptop.
> >=20
> > Instead it seems to involve reboots, which is crazy. From a cold
> > power-on start, suspend resume will always fail. But if the laptop is
> > rebooted first, suspend and resume appear to work. What the heck? I hav=
e
> > no clue how to debug this.
> >=20
> > So now it appears that everything I ever tried to fix this only seemed
> > to work because I rebooted after changing GRUB or module options.
>=20
> What graphics is there in the system?

It is the Intel i915 driver. It is an Intel i5-2537M system with the
integrated video on the CPU.

lspci shows it as:
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core
Processor Family Integrated Graphics Controller (rev 09) (prog-if 00
[VGA controller])

--=20
Knowledge Is Power
Power Corrupts
Study Hard
Be Evil

--=-iz8r/8tDVCwGHsPvJIp7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6GJ+YACgkQ1IRuMHS+h7E4AgCfYruMsbBU2x898zsBbnoUYknv
tTkAnRI8XURIc2MHIAd3CvipeOe6To3o
=ZUdx
-----END PGP SIGNATURE-----

--=-iz8r/8tDVCwGHsPvJIp7--

