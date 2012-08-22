Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab2HVROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:14:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55476 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964824Ab2HVROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:14:01 -0400
Date: Wed, 22 Aug 2012 18:13:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/3] spi: omap2-mcspi: spi cleanups
Message-ID: <20120822171358.GW7995@opensource.wolfsonmicro.com>
References: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
 <20120822165933.GU7995@opensource.wolfsonmicro.com>
 <CAM=Q2cvEyas6r8pb-edQ7UUJOE1YSxns9j5hA8Cz5pJnd4mPYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adlATi0AGRzVk0TM"
Content-Disposition: inline
In-Reply-To: <CAM=Q2cvEyas6r8pb-edQ7UUJOE1YSxns9j5hA8Cz5pJnd4mPYA@mail.gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adlATi0AGRzVk0TM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 22, 2012 at 10:33:55PM +0530, Shubhrajyoti Datta wrote:

> Actually there was a patch in your tree that I sent which is not yet
> in linus tree so I rebased
> it to linux-next to avoid any merge conflicts.

> Henceforth I will rebase it to your tree.

That's also a good option, though for simple conflcits it's OK if the
person applying the patch has to resolve them especially if you give
some warning.

--adlATi0AGRzVk0TM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNRNEAAoJEFJkBDiqVpZ4Zo8P/iYF5yuA9YIHUrnZesP9vmx7
yLloUIacKuQLON0N5YdSdXQsjRh0gfPJjAemcATjRracq19iV3XnFJA5qV9Jn3HW
h7XmV92O/HaRifcqQ65EMIT1PDAxU7seGinKsh4dFH4dS9u6fQBc20rL6O4DLZ6Z
RpKTgM75aoPgTGx4lzqQqKcPykNQJhs4ajzeiXMqssM+zDpcqX9Kj4RlrnKDO2zt
FSZgmXkZCB/MTzEvIg9bxBUqkEzRBb9CS8Kp2YIsRdLmyUorPHI8JGIKGRAaTjAa
uQiPzttiu+Kn0PD+CurDMwdtvNwu5W+PG1huB/mV6ugm7uhlJcdC/j/NwkrIFa3l
r3hni/VoMc68MUAA4cNQEFzqhdWwgeARCLTxF8NBuMJvog2Q0ESl76PDzelok2cr
WoOexHXBjuU/ndWsgTW1wdQIAuu9Y/w4nr/v6gYtjrE1XWmEp091gcQsHR5a6DtJ
y7/SRkSsOgfxR9OvDjsSdNqjTNFhObakj0zeJTLjs0UeIrPMHA8UuBugbu0twxqX
Xt4ALmyP3yLDKUVOXqVep7iqMZBhFFr7uoHjT38PEw//sIzGTgzMp5xH2UOXMJbR
G2ncwBjZBLoT1VNNmmM+K8pFVvDLw2i/QVDHpk/7i7JvIUcd5vutSzU4NZa/JtVG
zISatgFkDiYso04xSz17
=62sG
-----END PGP SIGNATURE-----

--adlATi0AGRzVk0TM--
