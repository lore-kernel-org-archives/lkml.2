Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623Ab2EWRNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:13:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42450 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760596Ab2EWRNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:13:44 -0400
Date: Wed, 23 May 2012 18:13:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: wm8350: Convert wm8350_dcdc_ops to
 regulator_list_voltage_linear
Message-ID: <20120523171340.GA4064@opensource.wolfsonmicro.com>
References: <1337785166.12699.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <1337785166.12699.3.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 10:59:26PM +0800, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Versions of both of these are already queued for 3.6 as part of a series
of changes converting the driver to use the new regmap helpers.  They're
not in yet as the core driver conversion to regmap is only going in this
merge window, once mfd is merged in -rc1 they'll go in.

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvRq+AAoJEBus8iNuMP3dJ+oP/jXVOnRUIggM4HFJAgULURYG
iJx6B3/pQpkAoAqnckQ5qTo7Jt2stdlwCIqd9Xnwf5YavLSlN1HLv5UiJg462qWk
O6mucBH/g/TEiW65imuondIuW6lT39OeE7wlUN454iatTiTsaPoWtrpD9+J5yuUQ
IivJ+6QSpuyd3Y9L6qOsXRx87wponso1qwo9HWmsyVnxW/juLvhd63aCOb3qZrCn
PIJMqF2lN1AeofDd0DiSu99mApImU3VOk3w0sqwerRPvDqTnH1HZgt0hBtUywLeR
n41NMfLgoku/FrgkqosSkYy1XrImD9hctBI/wc1OWVTG/W0BDIij+N+EuSFC2hIP
SQJ4IzltDE0jn83q1KA1XfOa1l+TavU7sov3CXScJ4JL7P02cRLKvsZ/q6c3GnD3
sTs6jhmP2oJgwxlf+43Pkehz1GatN1fXqDRskbtuMjgMNjykSLRptKYK0nRVQBFT
JlAtAJYrEp9HQuU3v37v9l9e8JFLBZmJkWOydRJT5dDZxK+4IdId8ke0B4iPgLjd
2T3d1F9Oszp6Ttyl8OYvP1B4BtFKnVVKo0g02AmSMrmRTKwnf9Jh9vSHDqwN3ZvQ
ClvA3t+ArLnroem+HmRdI5mZ+I8MSjh1xg1N7q3xbNr2hw3E46e9kq6SMogdZteA
HoLPsMsn3baOS5d1wiup
=BkaR
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
