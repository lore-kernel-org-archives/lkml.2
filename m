Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2FMRxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:53:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59011 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109Ab2FMRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:53:39 -0400
Date: Wed, 13 Jun 2012 18:53:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: wm8400: Adjust the equation for selector
 >= 15 in wm8400_ldo_list_voltage
Message-ID: <20120613175337.GF7804@opensource.wolfsonmicro.com>
References: <1339490095.6743.1.camel@phoenix>
 <1339490180.6743.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Content-Disposition: inline
In-Reply-To: <1339490180.6743.3.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2012 at 04:36:20PM +0800, Axel Lin wrote:
> Adjust the equation for selector >= 15 for better readability.
> The equation "1700000 + ((selector - 15) * 100000)" can be interpreted by:
> Starting from selector 15: Steps of 100mV from 1700mV

Applied, thanks.

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2NOaAAoJEBus8iNuMP3dlTkP/2FZ3MddBiZJoW1n2SsA6RsU
psyYaQQcXRl4hVr9x6eUEDnVHu0rGedVok7/zQjaoLpgBrcAHmbCH+ILcABrxTKf
oJZKkW1OD5sQYURFlt+IGFYnP4pmx7CXmZTa5IEKmnLBJajdJi4HcIoyJlEiI50B
2/MgiBw2pJIGDifJaDw7z0Fr7DVCAdQ0ql5nqSEpR5fGAu4fILp9tGyHJQlTw2RT
n4d4VNEOXTp7t1yr3A034FCOU8fki4dQnRejLFuqm7FGKkgxKUePTbGhN8SoDnaw
Zqlvu6kIqOwsAkLqJNltJRRERtGolaeMPLEpojUj8kXvT3bVZWZ0LQMQYTk/0awo
naORKtMDAO19dbA/bWr90DqWD+fIvBpuliSIBYdejs53lUAC01Lsalmes8MdYryC
V7/5/0XmjtrbPpsGVyjLUoVjCZUdIM/mw5cFeScVRkPgLYkMWAaeWx57sPjYpnsW
3F95w71b5SCXBmiDwBy2meQz/tk5DxqV8Eqvx1IIxG4SqwNPKAhOYV8Akgz5e5vy
KSjMkN/6tKa7t1UazLIYFeUoBUVVj5t1rIyhMOyTGzxIDQB51J5dki5Gu1orq6rt
T35hJ9CEDhtU7mvkeK4yDcTuBUQLS7CmzIIIEfmY1WpZguz9pE+hfUHv36gdEEmh
c2lGBb9cn2sBDUfqLmtn
=thB1
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--
