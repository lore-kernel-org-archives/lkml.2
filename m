Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab1JYN75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:59:57 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:40965 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYN7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:59:55 -0400
Date: Wed, 26 Oct 2011 00:59:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the cifs tree
Message-Id: <20111026005939.ad20ab7a2dacce216c69e821@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Oct_2011_00_59_39_+1100_hlTb9mrG9npMv6BV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Oct_2011_00_59_39_+1100_hlTb9mrG9npMv6BV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
iseries_defconfig) failed like this:

fs/cifs/transport.c: In function 'wait_for_response':
fs/cifs/transport.c:328: error: implicit declaration of function 'wait_even=
t_freezekillable'

Caused by commit f06ac72e9291 ("cifs, freezer: add
wait_event_freezekillable and have cifs use it").  In this config,
CONFIG_FREEZER is not set.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_Oct_2011_00_59_39_+1100_hlTb9mrG9npMv6BV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpsDLAAoJEECxmPOUX5FEMEIP/RLO5SYy6mbrYXWNjo8ojpWQ
LxfsRZ/Hi/aDT+KzSZCtZFBRs98MVQUPRDIGc74EP7smnxVmEZaas1mLUk6hdvh0
WtKVD9kKg9Lxqgyf1LzY8OBwPX8IbpzWP4MlnPiuoeYk+3cbpE/3r+QyWYAW7Ce4
MAfg2thplJfKE4+nZWfC4oVGBLI5NlHUsDckdvfKmxuULCbuRrHrQjw9r9Pevc/s
J51MATceo5cFXsKGWYhJvrVS/dGb6xcD3FeXUe+NGsFr68b+9JPSANL1Mr9J/Tw7
LOPOCIsTwdV+Vu3S/UeZXKL/CRFmrFeWiDN34uGVU87CDRy+0uFvVUn8CNDj2wb8
hdR2/uYled7V+vCCSGRGyKa01aJEsYK2IsqT+Ih4TlY4a90zFmO5Z2weG/WJOD9r
BAPxwMg4V+pOWwrME9aLTYd6iOkFV8OYWKTcebJ/7LcKVZFC+FhFKaTsW7uyvUje
fNQRMRJg2POAeiaL78lxaNOL+TYUtvuVeckFCBjAsXahN+OhR9JdNosjpRvwopAQ
RHF/Yo2rvxyN2d0JQ/TM27cRzxctmJ88RllssyfVAfr6Ay+ZFMdv/6CMM69QWsM5
Jm5lk/Jss0a7KaS4v36EDMEdiV6EqyROnqSi12twVDFkPBvcAThP0aNk/IJWsBz4
S4UM0prhQoQBzU5NJ9WJ
=Prs7
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Oct_2011_00_59_39_+1100_hlTb9mrG9npMv6BV--
