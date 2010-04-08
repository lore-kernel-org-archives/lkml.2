Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab0DHWqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:46:46 -0400
Received: from gold.linx.net ([195.66.232.40]:58127 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331Ab0DHWqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:46:43 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2010 18:46:43 EDT
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
From: Tony Vroon <tony@linx.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Hocko <mhocko@suse.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <201004082243.18393.rjw@sisk.pl>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
	 <201004072149.23791.rjw@sisk.pl> <20100408094905.GA3948@tiehlicka.suse.cz>
	 <201004082243.18393.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K/0H93rql4k+36vEP5IJ"
Organization: London Internet Exchange (LINX; AS5459)
Date: Thu, 08 Apr 2010 23:37:43 +0100
Message-ID: <1270766263.5923.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K/0H93rql4k+36vEP5IJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Rafael,

I have the exact same "lid close =3D powering back on" regression on a
Fujitsu-Siemens Lifebook S6420. Totally missed this thread before, but
I'm glad that I'm not alone with this one.
Happy to test any patches you may come up with; will an acpidump do for
you or do you need additional data?

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-K/0H93rql4k+36vEP5IJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAku+WrcACgkQp5vW4rUFj5o7LwCfao+JJhSbsGs69iLeUt7ISO6Z
ZNsAn2T42zn2P3Buv+oehxpNa6gDBs35
=MZQ4
-----END PGP SIGNATURE-----

--=-K/0H93rql4k+36vEP5IJ--

