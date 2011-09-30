Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab1I3UIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:08:09 -0400
Received: from 74-92-214-37-Colorado.hfc.comcastbusiness.net ([74.92.214.37]:36486
	"EHLO zlynx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1I3UII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:08:08 -0400
Subject: Re: Samsung Series 9 seems to require acpi=nonvs to resume properly
From: Zan Lynx <zlynx@acm.org>
To: rjw@sisk.pl
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 30 Sep 2011 14:09:14 -0600
In-Reply-To: <1317329529.3151.10.camel@knife>
References: <1317329529.3151.10.camel@knife>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YVcidAY6MNliwgXS/ON5"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1317413360.2629.2.camel@knife>
Mime-Version: 1.0
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20110930/1R9jNM-0006Ev-Me-linux-kernel@vger.kernel.org:zlynx@acm.org:74.92.214.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YVcidAY6MNliwgXS/ON5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-09-29 at 14:51 -0600, Zan Lynx wrote:
> After being annoyed that the latest Fedora 2.6.40 (aka 3.0 something)
> kernels would not suspend/resume on my laptop I followed a Ubuntu forum
> suggestion to use acpi=3Dnonvs. This worked, or at least it is working
> today with Fedora 15's 2.6.40.4-5.fc15.x86_64.
>=20
> The system is also booting via UEFI if that makes any difference.
>=20
> I understand that there is a no-NVS blacklist in the kernel. Should the
> Samsung Series 9 be added to this list? Or could it be a different
> suspend/resume problem entirely?

Please ignore this about nonvs. nonvs has nothing to do with the
suspend/resume problem on this laptop.

Instead it seems to involve reboots, which is crazy. From a cold
power-on start, suspend resume will always fail. But if the laptop is
rebooted first, suspend and resume appear to work. What the heck? I have
no clue how to debug this.

So now it appears that everything I ever tried to fix this only seemed
to work because I rebooted after changing GRUB or module options.

--=20
Knowledge Is Power
Power Corrupts
Study Hard
Be Evil

--=-YVcidAY6MNliwgXS/ON5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6GIeoACgkQ1IRuMHS+h7EsFACfaR44Pkr6pYVb3//DbpiDBE4Q
7i4AoM2FrBBkikzZ6eVVBRfpl5A9qUMS
=Smp0
-----END PGP SIGNATURE-----

--=-YVcidAY6MNliwgXS/ON5--

