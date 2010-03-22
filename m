Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0CVOag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:30:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50174 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0CVOaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:30:35 -0400
Date: Mon, 22 Mar 2010 15:07:13 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg KH <gregkh@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Fix key f70f4b50 not in .data in thermal_sys
Message-ID: <20100322140713.GB1076@pengutronix.de>
References: <20100309102754.GA3316@swordfish.minsk.epam.com> <20100309141826.GC28606@suse.de> <20100322135235.GA3388@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20100322135235.GA3388@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2010 at 03:52:35PM +0200, Sergey Senozhatsky wrote:
> Nope. Sorry, I didn't test carefully. Oh, Monday...
> Proposed patch doesn't fix the problem. The given below
> patch does.
>=20
> Note that thermal_zone_bind_cooling_device part was proposed by=20
> Wolfram Sang here:
> https://patchwork.kernel.org/patch/87359/
>=20
> So, Wolfram, we need to cooperate to solve the problem.

Looks good to me. Add my SoB, this should do:

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuneZEACgkQD27XaX1/VRsDHQCgupLJxbTbMb93eZiyXs0I57vc
PpAAn0fkLpBwQoKfVbL0wdXfyrKnCse4
=YtkC
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
