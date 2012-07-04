Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab2GDL4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:56:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52280 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab2GDL4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:56:39 -0400
Date: Wed, 4 Jul 2012 12:56:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFD] PM: Device tree representation of power domains
Message-ID: <20120704115637.GS4111@opensource.wolfsonmicro.com>
References: <201207032302.17805.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3bhLwMadv7h6/J9"
Content-Disposition: inline
In-Reply-To: <201207032302.17805.rjw@sisk.pl>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3bhLwMadv7h6/J9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 11:02:17PM +0200, Rafael J. Wysocki wrote:

> I actually don't have any ideas how to do that at the moment, but I wonder
> if anyone has already thought about it?

> For one, I don't think that representing a power domain as a platform device
> would be a good approach and I'm not sure how to represent the relationships
> between devices and the domains they belong to.

I guess the OMAP hwmod stuff is the closest thing we've got at the
minute (I don't recall seeing any other implementations in mainline) but
the hwmods themselves don't appear in the DTS right now.  They have a
ti,hwmods property on each device naming the hwmod it's in, something
like that seems like a reasonable approach, possibly a reference to
another DT node rather than or as well as a string?  That seems fairly
easy.

--O3bhLwMadv7h6/J9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9C8LAAoJEBus8iNuMP3ddOsP/1X4nGyjtiBMpLM7HAym0Mf3
KdVkAZn9C1UsiE+ZM35Fk/EaABFOhdL6Twhc2sf3Ho6K0lrzmD/yUILJbnfaBAc+
EGSJg0L6qBJwj24U9He4OVzSGvjGeYFDQW2KA8Etk8Vm2iI7QqTtxaYD8kEKZ3u6
4J5UamR9MTrqx9jtyU9/n+phGwmflEgg5Cu0WZHU4+0/cWX5IsI6B/2TlOuXnqqZ
VzijAcqW2fq/cPG4AyUxGksLP8Of27cOpFDFNLr8gs1Oe52NjtJL0vqtXuTuocrp
73GhyH+XQC48B0TQAV0GNEfj9Mq6kbhFZcEh5Ez8yHl1fI/OG3ZhxNsBjrnytZnY
KdB/Bzt4afiyPqmA089LXavVCaesgf+G7jtCwZR0qNKAiVokfRGJ3Igrvy1nodWU
XY3SHtOuqrkRAL9HuWk5B2H6OiBnU63NBlAHXFsgpMBp9OIWKFe7gj/zEhuVBtgg
M3RwyHRg9GkZzkOfH7bmRbwKfRQs/6d+be+8OXoSGAmsUiJsVu6R7yH6xpkAqhlg
4/NOXVIwiJnow/ifpoUdBtal3GksPAnmg5MkHQOXwrjKgnQaSQthtmyWABFAstmz
tJFAJ5H6AsKflHR+qlD1w4bO4+wERwG+CvrpCIyvJP73KbFQeyMr4VfNIpiZkb49
Y7/K/+0d16QMTifCbGNl
=pZIz
-----END PGP SIGNATURE-----

--O3bhLwMadv7h6/J9--
