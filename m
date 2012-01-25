Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2AYGZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:25:54 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38076 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2AYGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:25:53 -0500
Date: Wed, 25 Jan 2012 09:26:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ilia Mirkin <imirkin@alum.mit.edu>, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 1/2] Staging; bcm/CmHost.c: Style cleanup
Message-ID: <20120125062658.GR3294@mwanda>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1201242345140.27508@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XAEV7zm15O60d1Zf"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201242345140.27508@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F1FA067.00C3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XAEV7zm15O60d1Zf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is probably going to need to be redone on top of the other bcm
cleanup patches anyway.

On Tue, Jan 24, 2012 at 11:46:31PM +0100, Jesper Juhl wrote:
> +		pstClassifierEntry->ucDestPortRangeLength
> +			= psfCSType->cCPacketClassificationRule.u8ProtocolDestPortRangeLength/4;

Put the equals on the first line when you break something up like
this. Also the real fix here is to choose shorter and better names
than "cCPacketClassificationRule.u8ProtocolDestPortRangeLength".

If you're breaking up a condition normally the && or || go on the
first line as well.
	if (foo &&
	    bar &&
	    baz) { ...

Although that's not in CodingStyle so it's not a "redo the patch"
situation.

regards,
dan carpenter

--XAEV7zm15O60d1Zf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH6CxAAoJEOnZkXI/YHqRYvQP/RLMOXwWK3jIJfOoS8+AyGom
G3A8nXpsqfXM3W327EJhLfg2K+PQMQcI6irw7jC+hs3XhIooG0Ct/it4vCzUapIg
uX6nejUt3CaTehNVimE94raWXO6woB9Vy+54ED78AP6cD0JT32Z/K4gME/03bkJU
m7biCwqlF7uM9epcAbtWW1enXBT1WtKNqZKwJl0/V4hddpmNuhNNIK5pkFMDX66N
e13bCEab7ri2HCdk4QWpCaaRnBR0+uijI4fvIsJkFabSELEZyLUl5fxXtQbW+REg
wVgndBDIbLXOi3gcghZu8hnYZaPehgcg6EVa0Isu7eIjzv8WBz4z5XVwskMemOof
p48hW8Z0ie1NdlW4+osmbPpY4fwx9gPVO0FhkIlYTjE9RiHgASlBWWRvkF5Qys+E
FOsZJONwsy5m+uQp2nM7NWBDCMZY6McELxG5xRxaQcEQZsEj078UZIXI16SKBthn
gB4/JrvV2Jbv7surID6vryyH8wGOADSt3DGs0Eo/XiVm8RvSMOfntTA8q/5ymMJz
BOX7rFxoONCtX5NnQQ8TCO7Sqv0+uvge3is/SkRFG145JrNkK4vXtxMFlXazm8Ue
yqf1LmqFy6CFMyeYps2pv69zljJovWolAsMC3+WAsOuhQc4+fSVUyVqt6XpPLo88
arRsy1AhMbxc75KQVtJw
=GCQK
-----END PGP SIGNATURE-----

--XAEV7zm15O60d1Zf--
