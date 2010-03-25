Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0CYMQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:16:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0CYMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:16:16 -0400
Date: Thu, 25 Mar 2010 13:16:10 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: isdn@linux-pingi.de, davem@davemloft.net, linux@dominikbrodowski.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
Message-ID: <20100325121610.GB5069@pengutronix.de>
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Henrik,

thanks for the work. Please, just keep the placement of those attributes
consistent. Otherwise it might be easy to miss:

> -static int sedlbauer_config(struct pcmcia_device *link);
> +static int sedlbauer_config(struct pcmcia_device *link) __devinit ;

Wrong.

> -static int sedlbauer_probe(struct pcmcia_device *link)
> +static int __devinit sedlbauer_probe(struct pcmcia_device *link)
>  {

Right.

(I think checkpatch checks for this, too)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkurVAoACgkQD27XaX1/VRty6ACdGQgKpKB3pJYfiNmH2LtVfFHl
JGYAn3enpHJWxEnYbwasrk5aYZ+SrdUN
=MyC6
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
