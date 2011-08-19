Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1HSNsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:48:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44611 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1HSNsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:48:03 -0400
Date: Fri, 19 Aug 2011 23:47:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20110819234756.ef70fa07dccb6adc17d2f516@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Aug_2011_23_47_56_+1000_lmIgiYezd/R9tAsI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Aug_2011_23_47_56_+1000_lmIgiYezd/R9tAsI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (most of the arm and
avr32 builds at least) failed like this:

In file included from drivers/base/power/clock_ops.c:14:
include/linux/pm_clock.h:15: error: field 'nb' has incomplete type

You need to include something that defines "struct notifier_block".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Aug_2011_23_47_56_+1000_lmIgiYezd/R9tAsI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTmmMAAoJEDMEi1NhKgbslFgIAIcdmybVNXfAkNS4n91ox+eO
Psv/OHvPrxBDnU+Dwzg4IHyNQjU0lk8VB+/A80n+rzKLEodnfaYe99Nc1Sk8y502
IdEqgHKMEIVXoya53cpsNmhzNGwM0CX3luRfnZeYId8M7JGFa6hXR9vCUODCBJM3
GojxeNiNmu+Wu2jP+jK6LvvlV3Hg2P7Znh+g8n9uigAm9kKC6gQrmP/lnBwGmdue
/u0a4u6qhn70CjaYzfYW+DwdZ5qagZ4fkU1bsikVn5eUfWDGH3MysyDzYKpkDWsQ
lj7631OUhGXbDRC+2MKMYiDLXbL3pmV3baVkCKnJdye3Wfa95p60eNCo2aNlQDE=
=lUik
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Aug_2011_23_47_56_+1000_lmIgiYezd/R9tAsI--
