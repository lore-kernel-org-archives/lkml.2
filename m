Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2KIVpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:45:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab2KIVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:30 -0500
Date: Fri, 9 Nov 2012 22:43:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: harmony: Add ADT7641 temperature sensor
Message-ID: <20121109214326.GB9023@avionic-0098.mockup.avionic-design.de>
References: <1352465815-26984-1-git-send-email-thierry.reding@avionic-design.de>
 <20121109132257.GA29183@avionic-0098.mockup.avionic-design.de>
 <509D76BF.6030808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <509D76BF.6030808@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:b0bl2Z/wAuKf6SELtB7RE7P7sPV0NqZaUrVA0f4jCoX
 oG4Sb1XLQtXIQu7hM940UeNlFhkAbHRmft9h1XwHJ9svXbRLtv
 daYZIkvjWPR5U6hC2mqIEO+xPEeSJ7gixVVpv3Brhex009haEs
 HyQev3Qj0AAaVIXd8YxjbHRDkVDNmymlwfQnc2Pv7Z3Zs+4ZYM
 ig6yf4JqnYqEh2r+uOQ6woG5lI4aIHuADOaWoP2U7FJK/JBcG+
 evX/CHMG/fhqooLipHpW8+V5DPOLdWpAUriHxfCYiikJPwXait
 UFLdbVZMb85dEBev0mHtbfHRD4lz5tg3hLUhz0g6LysL7mWFhN
 3T4Bop1/EKAGwrxKv7xB5U7Ou+vju3+yuPpJh+ulzf/I8sfz3b
 XEifZT0Tt8ww/GXtZ4WKsvnHVT7Tp4org+CsmyKW7rU6ghZXZI
 ttCjO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 02:33:51PM -0700, Stephen Warren wrote:
> On 11/09/2012 06:22 AM, Thierry Reding wrote:
> > On Fri, Nov 09, 2012 at 01:56:55PM +0100, Thierry Reding wrote:
> >> The Harmony board has an Analog Devices ADT7461 temperature
> >> sensor connected to the DVC bus. It can be used to monitor the
> >> ambient (local) and on-die (remote) temperatures.
> >=20
> > Note that I haven't actually tested this, as I no longer have
> > access to Harmony hardware. Testing can easily be done either by
> > reading the files from sysfs directly or by running the sensors
> > utility from the lm-sensors package.
>=20
> Tested-by: Stephen Warren <swarren@nvidia.com>
>=20
> Ventana also has the same sensor and due to git am applying your patch
> to the wrong file (I've renamed all my .dts files), I ended up testing
> that too, so you may as well send a second patch for Ventana. Ventana
> has an nct1008 though.

Okay, will do. Thanks for testing.

Thierry

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnXj+AAoJEN0jrNd/PrOhdUkP/RpgvVn/F8qXVq7qCCmDiaoe
OrThFJEn0pG7Or7KWkzjlYJMhUhyyBPlEGtuR/Es/TcbKFRh73++9YvXMBBt7uCJ
hqDYaLmcKunvqA7OP4GHfNOqry/OU7LSf+vEIhcDfcYd2JbU7M9iAu57662fJbee
EW52WkDIa76yC7RJJ/kE7zC+h4niUXdwaExn5IHfmdaA07jawLUa/KZ71yXuhMnb
bxEU8cuz+vombaV8LyBzc5wk6aCYZTX2Ul33lD8IeogntDd2MfwZzIqNalA89Y2T
raJZHZ8nfGoNxgsnOTJVsEig6PTjKwOQLhK1EKq+DTaRtW6MdZUty7HAU5hccQdN
i056+Mt+/J3suvjZCo1u0dXW/eU1UJuNCkMsyfGt3Igp3akvEdfTYl1Ue7mZoYeC
q3L4b+nDl1T84CoddrOeln1t8NqJEopvim0PqQCkq3PLasi3KeUOn7Ff4DSd2enO
f5oPnoMBF51ebVuaxfIbi93OcqMshb1mcH4+d9QhT2IbcAk16V2BRwWpw+VSNhbc
TXyd3DUe2PQYvr/MxFvH0UldT/5aFWAgCbokUge0KFtDWLACXlQ49AE3M1S/QOUL
ohN7EP1rmQRfhF3LGED93M5aDF+CC/StfgfMw7/c4NhjiGTsjy0wBsPxcv2tcxi0
gAMEP5FwKFh9zJrsvqoX
=LU2t
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
