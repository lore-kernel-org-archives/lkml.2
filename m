Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0K2KIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:08:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38139 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0K2KIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:08:17 -0500
Message-ID: <4CF37B86.6030708@pengutronix.de>
Date: Mon, 29 Nov 2010 11:08:06 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com, Samuel Ortiz <sameo@linux.intel.com>,
        margie.foster@intel.com, netdev@vger.kernel.org,
        Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, joel.clark@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 01/19 v5] can: EG20T PCH: Separate Interface
 Register(IF1/IF2)
References: <4CEF150A.7080409@dsn.okisemi.com>	<4CEF84BE.7000101@pengutronix.de> <4CEF864B.6080207@pengutronix.de> <002201cb8f69$11d30050$66f8800a@maildom.okisemi.com> <4CF370D3.7020606@pengutronix.de> <001501cb8faa$3cc7f220$66f8800a@maildom.okisemi.com>
In-Reply-To: <001501cb8faa$3cc7f220$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig902E9101C6EBAF5795718CB5"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig902E9101C6EBAF5795718CB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/29/2010 10:46 AM, Tomoya MORINAGA wrote:
> On Monday, November 29, 2010 6:22 PM, Marc Kleine-Budde wrote :
>=20
>> Maybe your patch description in git commit is unusual. It should be a
>> one line patch subject, followed by a blank line, then a multi line
>> patch description.=20
> Adding blank line below subject line, I could confirm=20
> whitespace is not inserted.

\o/

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig902E9101C6EBAF5795718CB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzze4kACgkQjTAFq1RaXHNvPgCgiUFJob2VcE/1sfE2qDFDmT3v
rIQAoI9lPqVQLyeaHquxZTrUcGiN5bts
=MBM7
-----END PGP SIGNATURE-----

--------------enig902E9101C6EBAF5795718CB5--
