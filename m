Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3AHKnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:43:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58520 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab3AHKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:43:23 -0500
Date: Tue, 8 Jan 2013 10:43:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Message-ID: <20130108104321.GJ4544@opensource.wolfsonmicro.com>
References: <1357371223.22227.1.camel@phoenix>
 <20130107110818.GB4544@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998F69E11935@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6J7GEvtanOfV9oXA"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E11935@DQHE02.ent.ti.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6J7GEvtanOfV9oXA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 07, 2013 at 11:23:26PM +0000, Kim, Milo wrote:

> > Applied, thanks.  However we should be converting the driver to use the
> > core support for this - the GPIO can just be given to the core in the
> > regulator config which should handle everything transparently.

> I have a question.
> Do you mean the dependency of CONFIG_GENERIC_GPIO in this driver?

No.  I mean you should use the regulator API core functionality for
managing GPIO enables instead of open coding it.

--6J7GEvtanOfV9oXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/g/AAoJELSic+t+oim9rK4QAJBfTDemX+WYzEp0fW2zaGqe
5IWlBa86a26BDLviPVSytC2Bdg/5lotrcWpl8n/u78sfFS4c1W/e2SbrtqMJSZ0B
Td7GexehPzn9FJ+Rn/Fju9WsSZ+FFWMB/KNNzBBI68jIHKY/H14PMY920Uet5T14
A4YpqmlkqkFk36A1t1ZcxRcKiijc6cX2fUgjHIfyNZmjzybi0N15/GtQGaB2pLTI
OndWtHGvCTwKbSHM0QIseGcDLa2CM49yeuhPrbvKcv2CuyfGXDC0WW6TJJl4ehKA
1vMesKN1A/C/BeUehCmmiZJld/SBigpJlL0D9DBMhBRfgC+brNtUXqw6wYlrZizB
X0TxR7kNMJx+JvijlQOl/EpWEg+TxOA186asYHksc2AtEo4y3Yk1LLL152VIl98j
DlPwrGLn0rBhCGDWVAnEazgw4zs8suzR6+TXottJc+BsAT9YimMOTl1Fk3j5qdNs
+UmUs0zovbqBU8qotEAOKOKD/XlB1nqBzUAwq3/iLD6xA6cEdE9UoQb3LuzQII5b
rJMh5+y8OY5PgS0V2LIIK7+YRUIl8jROAyleWqBzniMylANt+s1R+OBgBo068Qst
nu6tT6xqrVrIov2gCwySzpfSczXp32gQvnNBtKmCWfkA543mrq/XpxvDZknN5lrC
hIbhcoPBChEapkS659HT
=AeoF
-----END PGP SIGNATURE-----

--6J7GEvtanOfV9oXA--
