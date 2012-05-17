Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292Ab2EQLpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 07:45:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37584 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2EQLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 07:44:57 -0400
Message-ID: <1337255093.2564.3.camel@koala>
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Date: Thu, 17 May 2012 14:44:53 +0300
In-Reply-To: <20120517124548.262c132a@pixies.home.jungo.com>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	 <1337101871-31181-2-git-send-email-richard@nod.at>
	 <20120516170324.337f2932@pixies.home.jungo.com>
	 <1337178457.24809.56.camel@sauron.fi.intel.com>
	 <20120517124548.262c132a@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3HTtGbtBfrxuNWizH4BF"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3HTtGbtBfrxuNWizH4BF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-05-17 at 12:45 +0300, Shmulik Ladkani wrote:
> Hi Artem,
>=20
> On Wed, 16 May 2012 17:27:37 +0300 Artem Bityutskiy <dedekind1@gmail.com>=
 wrote:
> > On Wed, 2012-05-16 at 17:03 +0300, Shmulik Ladkani wrote:
> > > Comment above the function should have been changed too.
> > > (look for the "next_sqnum - get next sequence number" comment)
> >=20
> > I do not think we should make these non-static. We should re-use the
> > entire scan_peb() function instead to scan the fastmap internal volume.
>=20
> Sorry, couldn't follow you.
>=20
> The new (outside eba.c) calls to 'ubi_next_sqnum' are from
> 'ubi_write_fastmap' (called from the 'ubi_update_fastmap' interface,
> implemented in fastmap.c) - during construction of VID headers of the
> FM_SB and FM_FATA.
>=20
> IMO this is reasonable.
>=20
> Do you suggest to somehow use existing ubi_eba_write_xxx functions?
> Or place the FM_SB/FM_DATA peb writing funtions into eba.c?

I think I meant the compare_lebs() exporting, not this one, replied to
wrong e-mail, sorry. Happens when I am in hurry - try to keep everyone
happy and make sure Richard is always busy with something :-)

--=20
Best Regards,
Artem Bityutskiy

--=-3HTtGbtBfrxuNWizH4BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtOS1AAoJECmIfjd9wqK0FKgQAJUerJnTZzO0y5ulj2m2ee10
pmrWYBrQCUB88mgHIlXo9qsTKp/Vq9HcSvYUOI8C3nFyM8Fwj+uQhQa9WlLGTvHn
+TpPbr8zwoYYLyWskBd3GKUhOGVAOhQG5dUYw6+i/4cN5dxxH6rH8dtefEn7HFkE
1f1GvzBA9p37A8hakK/K8DJ/tqIlfdxF/oEU21YeINUw42AhSael5akxsHSjazIE
fFzMLMyAf0m4agpMp6Nmp6eaQQGnKiNbP1vhjDXC6FJScC17WHYdECRpkmDReQHv
KdbtTfbOud3OdQ9N7xbMq1zbTYVfPn0f6k0glWBezg0FtpY1r1+OVovZbVELEdIw
cs4jkbGoXkBGoTRd5UNIrcXbTnxSh8MyfpgQkRGPOFfpgc3EUfsWzH2hjEpJN3Mt
hBswvesshV1REnRKh05ekzQFv2AS3ES2JFrSYFhkKmLeXfRVmGcLcYBS39+T/tq9
AtOPyo11ml2DFfmk2HtUCmMZTxPz63C5IJuZYWmpEPM95mGYofmzjsvA8ViEczIf
wheNeyKMwHpFBlugowRs1Pxqv6wfiAsj0dHGkPlCkStb+OFFwQia62AoXpMB+L6G
A+D+1gbOK06wX15muQha/aQXGlGJ0bo0Vf5PtGTMtL/S7xyHqlIGq1MJhDmR8Q0W
wVlYr3DixWremZywSQXM
=vkza
-----END PGP SIGNATURE-----

--=-3HTtGbtBfrxuNWizH4BF--

