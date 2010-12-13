Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0LMTk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:40:57 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:38818 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0LMTk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:40:56 -0500
Date: Mon, 13 Dec 2010 12:40:47 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] mm: kswapd: Treat zone->all_unreclaimable in
 sleeping_prematurely similar to balance_pgdat()
Message-ID: <20101213194047.GG3401@mgebm.net>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
 <1291995985-5913-6-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Content-Disposition: inline
In-Reply-To: <1291995985-5913-6-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Dec 2010, Mel Gorman wrote:

> After DEF_PRIORITY, balance_pgdat() considers all_unreclaimable zones to
> be balanced but sleeping_prematurely does not. This can force kswapd to
> stay awake longer than it should. This patch fixes it.
>=20
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Eric B Munson <emunson@mgebm.net>

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBna/AAoJEH65iIruGRnNUC8IAIv/gHOr5hMbbr+j2VeoaBDp
WZAv+whu//uAGrEYjo6aa+KNouBwvn+xnlpy3FFKZa42tiHduO8o1PT3WN5/6WPL
Sj2Am3NveFf1HomT59+Zu8cSNje0xP297erigL+fxQqLpy18R35xEkirkgDjEl8y
W00r3kJ5EK1NDyckpWdlreCqoC+dCpz/AgfQ3U9PXiRRR1kGikju45rT2njf5N20
AX6RXiLQNR/4+VJIVhFBgn/AiqWM5x8U6+HQxQD7Yy8EFN4I0pcdEPiohjIci98e
LCma82tDgQAjgSDRRx9+DsXlftgV9UXa7kxW3PpEeBufaGJ4ui1FKxPhKSvLpd4=
=XzDQ
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
