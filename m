Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab2EIMfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:35:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957Ab2EIMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:35:03 -0400
Message-ID: <1336566889.8274.346.camel@deadeye>
Subject: Re: [ 024/167] [PATCH] md: dont call ->add_disk unless there is
 good reason.
From: Ben Hutchings <ben@decadent.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Ceuleers <jan.ceuleers@computer.org>
Date: Wed, 09 May 2012 13:34:49 +0100
In-Reply-To: <20120509172022.73159017@notabene.brown>
References: <20120509055029.588587017@decadent.org.uk>
	 <20120509055032.897593072@decadent.org.uk>
	 <20120509065717.GB32230@burratino> <20120509172022.73159017@notabene.brown>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xt9MP9HIOHlmv2piVktM"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xt9MP9HIOHlmv2piVktM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 17:20 +1000, NeilBrown wrote:
> On Wed, 9 May 2012 01:57:17 -0500 Jonathan Nieder <jrnieder@gmail.com> wr=
ote:
>=20
> > Hi,
> >=20
> > Ben Hutchings wrote:
> >=20
> > > 3.2-stable review patch.  If anyone has any objections, please let me=
 know.
> > [...]
> > > commit ed209584c38fb74b7eecc03e5b1bfe674e591bd8 upstream.
> > >
> > > Commit 7bfec5f35c68121e7b18
> > >
> > >    md/raid5: If there is a spare and a want_replacement device, start=
 replacement.
> > >
> > > cause md_check_recovery to call ->add_disk much more often.
> > > Instead of only when the array is degraded, it is now called whenever
> > > md_check_recovery finds anything useful to do, which includes
> > > updating the metadata for clean<->dirty transition.
> > > This causes unnecessary work, and causes info messages from ->add_dis=
k
> > > to be reported much too often.
> >=20
> > Does 3.2.y need this?  Commit 7bfec5f35c68121e7b18 (aka v3.3-rc3~3^2~22=
)
> > does not seem to be part of the 3.2-stable tree.
> >=20
> > Jonathan
>=20
> Thanks for checking!
>=20
> Probably not needed then, but it wouldn't be harmful.

But I don't think it meets the 'stable rules' for 3.2.y, so I'll drop
it.  If it turns out to be a important fix even without the earlier
change then let me know.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-xt9MP9HIOHlmv2piVktM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6pkaee/yOyVhhEJAQrxVRAAn7dKtKfDsRGyk6eJgI+YznTzDQfDqJH8
uWqQxRW1lIzUC5GKmwfGS+6Qv318QTg6863lLbXerSA1QCv8WOqoRSfZDrySA4I8
PrPhgStuOU48noaGlcyAuavosLnMlBfhI9CHsEzk6nuLgAHOb47mvLkLINrcFFs4
MMrAah3m+7ytSTot+9L9ShjMBBeGj7yP+felJTpP6NwSUQTkRyYUdUEMR7TYAIm6
Es+Dl8xNivsbTg98BUTGbT0nrNaBRkhstC/yjEaKEu4YQsoak/doTzg5aHYlxYIM
UGrIz/9q+46OitYf5lfz7rlVVVTIkdTSxACqXBdYu8+qUf29vjXYyhKzdFGWTz7s
FEoSiLMHV58BKn3uWJ2neA9JcQuoNcY3go2NK5Twnst9bbSB4o5F7GcphEzl6pvR
ueBNGOCCT5Qtnt+XEKRBoWeLvgZIh7WKgSNv3p4CLNMBAV3J2GcUDQ1D/IhTgSgI
bDudOS2bHJPI1w+1fZ7EDPZd9PCsLA4tz2MCnays7eqVp4Q+rMjAezdl5kbjfwx8
bQK3UjUhkd5Qg9Nh7lIy3XnlUimHOB5UDFCeGbdur+MWRAg61pKnA6IIAmPOdyhk
Tx6rIOQU+dREUeBp2enF62+DZc8d4NN9rr0W93vnIHKj48QUbwUTgenq32IqE2o3
PRNPSm3UyaY=
=R4M/
-----END PGP SIGNATURE-----

--=-xt9MP9HIOHlmv2piVktM--
