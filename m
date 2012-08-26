Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2HZQnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:43:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55677 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab2HZQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:43:17 -0400
Message-ID: <1345999370.20840.13.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2012-discuss] Pubring and instructions for the KS 2012
 keysigning
From: Ben Hutchings <ben@decadent.org.uk>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: ksummit-2012-discuss@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 26 Aug 2012 09:42:50 -0700
In-Reply-To: <50387307.9070001@kernel.org>
References: <50387307.9070001@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JMiU/rNbDNB/XZs5Yvmo"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 12.105.246.2
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JMiU/rNbDNB/XZs5Yvmo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-24 at 23:39 -0700, Konstantin Ryabitsev wrote:
> Hello, all:
>=20
> I collected 46 keys from 40 people interested in keysigning at the
> Kernel Summit. I have uploaded the fingerprints and the pubring to the
> following locations:
>=20
> https://www.kernel.org/ks2012-fingerprints.txt
> https://www.kernel.org/ks2012-pubring.gpg
>=20
> This is the sha256sum of the pubring:
> bbb816d955c3939c72985175b0ea4f8781662f70d8a0fa9b0985391403a0fe79
>=20
> You can import the pubring using "gpg --import" command.
>=20
> WARNING: just in case someone jumps the gun -- these fingerprints were
> taken at "face value". I DID NO VERIFICATION WHATSOEVER whether these
> keys belong to the actual people. DO NOT sign any of these keys
> without the verification procedure at the Kernel Summit. My GPG
> signature on this email is in no way an endorsement of these keys.
>=20
> Here's how the procedure will play out:
[...]

You seem to have missed step 0:

Verify your own key fingerprint in ks2012-pubring.gpg by comparing:

gpg --fingerprint $KEY_ID
gpg --no-default-keyring --keyring ./ks2012-pubring.gpg --fingerprint $REAL=
_NAME

(Normally, people would verify their key fingerprints in
ks2012-fingerprints.txt, but unless we also agree the sha256sum of that
then no-one can rely on the contents of that file as more than a
checklist.)

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-JMiU/rNbDNB/XZs5Yvmo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDpSCue/yOyVhhEJAQqjHxAAiUe1FeWpgUw8nHHsOLaQEYL75QhX1TVP
vig7SZ8qNDYrLbxFb4l5KPTFgZNF9FCIXUJs9WNpDhbZN+q25B2a16+AFhO7RA2j
sLxO4qZi8ZkvtM2KQiC7TR0fAsXByhwTca5cfVJfMeIlzUg2JyaJNOc3CBNulu7M
KD285i7+MNuw1VUo+94eF0kxEkYrwrJ2hd99wN7TTqL+RMKrb8jEpr1Wz1/iDGC0
wt08IX1WHm6BNA+78vKrVj4Il45uB0Qud8kYwUd+6eIVtubmQSFCbPfdIb19cu0/
MP/WmtjCRPlEf374rIxAaAfMa3FsUVqWLxIfwdngpTRGk4SF35HGw2BUWSOAuHag
37fgtjraQFfhLtRIbWbT9EUcxYrhyf1bjqaDJmelvY+CzolPh1cDvBJPj8JwAArY
AnRiytPwu8gtyPCl73Itx4GWx5TtGf9ZNISXTCACeoqKeB0Yx9/KKM1nsekK25Ug
Nk6uLvk35k8ys0Q5rl78YSjlJzyZeNQssH2HU0Nw45/pE6dACpSOu8h2MpexSTDw
jEATHDjOi2LG/dzrUZVF1FEetr6IztNH6O49zSSX2Y1mhkqyA24QYeO87CbRdJpX
fNUBKdb4ghKreQ/y7CZHW+AqfnvH3xh2gdkZWmZw+LUNyOQZfXQ9YHe8aM4OlzCi
TpY4WtvnJWc=
=JAhI
-----END PGP SIGNATURE-----

--=-JMiU/rNbDNB/XZs5Yvmo--
