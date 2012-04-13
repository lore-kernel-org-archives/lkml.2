Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2DMPkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:40:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:12866 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab2DMPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="130604961"
Message-ID: <1334331824.2544.90.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 15/17] mtd: mark const init data with __initconst
 instead of __initdata
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kernel@pengutronix.de, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Date: Fri, 13 Apr 2012 18:43:44 +0300
In-Reply-To: <1333055554-31300-15-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
	 <1333055554-31300-15-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-oLmLqvWooHq432dml5cQ"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oLmLqvWooHq432dml5cQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-29 at 23:12 +0200, Uwe Kleine-K=C3=B6nig wrote:
> As long as there is no other non-const variable marked __initdata in the
> same compilation unit it doesn't hurt. If there were one however
> compilation would fail with
>=20
> 	error: $variablename causes a section type conflict
>=20

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-oLmLqvWooHq432dml5cQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPiEmwAAoJECmIfjd9wqK0xywP/1V3+hgSXMGyGdCjsm+rFFxe
bzFaGQ9L8/+O/zl2/Xgg0UBkqdHbm3VEKxUy6KWd71QcPTrJrVy6qYb538PqqINW
3nxUX3Jv6ffe8gH3MbYkEtpBOfVWgznZQ0QSVqHqujxALkQqNYzkXLGkwMR3e2X8
q6j74X0uNSUAYU+K6pekAT8Wf4XoLw/orGQW9InM289MpsmF3qVccruGxLppiCRn
ZMH1Ctm24D1rRKmtJgbvWH+y1rsiHjh71IeUOHHQpXFUKG/1RYKc4QytUbDixUys
T25Xy45XzzM/j15WY8h1jGVrsiIL+Fu7/+NPXdV0XrG192iVzz0wliKgp13/SyVx
9EhoCunSv74tpo5X6w/XrbnNji8ABiQmDfcy/kI2tHBFOOZOLa1EZx1p8NiErtgF
WkRQ5jrcObPlcOAtO+Uoz3jrtlEFxmrW20BSH245nWpWBo0B97UDFy+9ZVO+Vi6u
IkA58DICaeXuRRRJxdTBcYARBXYz+JfTyQtRr7PoIL38A1fwBOHy3U0w10j0Hs5w
JmW9sn+nSNISbE3O7/fM/3rIeZV5d8vNzo5XZ1xws8dSgwJnFmze3i/r4aHEwhuy
RacIk61leyArOlpSa+zZwWp02T4nQGay87ork6sfZTTr3qfTxFPdKSo4bdDnCJB5
0Ltq6KfmUK+uPB/86Cg0
=lifi
-----END PGP SIGNATURE-----

--=-oLmLqvWooHq432dml5cQ--

