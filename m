Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1LUB3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:29:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45507 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab1LUB3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:29:20 -0500
Message-ID: <1324430940.2844.144.camel@deadeye>
Subject: [PATCH 0/8] Fix virtual and physical address types
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org,
        Kevin Curtis <kevin.curtis@farsite.co.uk>, netdev@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        rds-devel@oss.oracle.com,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Date: Wed, 21 Dec 2011 01:29:00 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-auuee/X1upD+bQMYrTHk"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-auuee/X1upD+bQMYrTHk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This series fixes compiler warnings on some architectures about implicit
conversions and narrowing conversions between pointer and integer types.

Please apply these to the appropriate trees.

Ben.

Ben Hutchings (8):
  IB/cxgb4: Fix formatting of physical address
  farsync: Fix confusion about DMA address and buffer offset types
  drm: Do not include page offset in argument to virt_to_page()
  drm: Pass pointers to virt_to_page()
  [SCSI] tgt: Pass pointers to virt_to_page(), not integers
  uio: Pass pointers to virt_to_page(), not integers
  rds: Pass pointers to virt_to_page(), not integers
  pmcraid: Pass pointers to access_ok(), not integers

 drivers/gpu/drm/drm_pci.c            |    4 ++--
 drivers/gpu/drm/drm_vm.c             |    2 +-
 drivers/infiniband/hw/cxgb4/device.c |    4 ++--
 drivers/net/wan/farsync.c            |   19 +++++++------------
 drivers/scsi/pmcraid.c               |    3 ++-
 drivers/scsi/scsi_tgt_if.c           |    2 +-
 drivers/uio/uio.c                    |    6 ++++--
 net/rds/message.c                    |    2 +-
 8 files changed, 20 insertions(+), 22 deletions(-)

--=20
1.7.7.3



--=-auuee/X1upD+bQMYrTHk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATvE2XOe/yOyVhhEJAQpCPBAAzxsxERWWaiZhuyPldAGrhVCYw5gYv014
kiOOfmLRnZXeRxRVFi7ZJlV603NvxDWL3/FGtjFvwDI5CTxb6wqWjjzvp+fCcaET
O6pv6ehpvSISQM0mmkpv2shy8+f7+IZtVB9xRpPmWnQ4lE2Nbc5JhjqQcmBb4bPx
QYymccb4Xivg1a4i9R0zMeKsQ9oNS+SqZy3zJmGNhUFVVc7f/OChbXfGueFHtJ0u
NOZz7bA9wD+tbm6PkGjjHpZ7vWPIDcJQ/n5CRo9LSgSY7BwwTLHd8Cwgz7tzrfTt
emvQHA8kqN9tob486h02GAj3ny9GwfQZb6wDRsrmbhw4ahbeULlzfOxjLW76f0kf
OmyE4xqFx7PqCJD8bT3Sw/JDCtF08CguJabEXpqzAPkgc+rmGdYr9pTxlJ1WeHCZ
Q+Sv/pD88Jmn2USwg5fTNZcrTny39e4wMmLY1qKU5md5Z01RfQhEpzXWczrjIWeH
hBR3GJr29lS4uodvex9hoMIK+N+KxIeWQe6o4lTcKuCQ6RjanB+z9CKTe7yejQri
rvoHHmdkFFa/6nKDYNkp9UmODE4Aja3f1BRn/9VLEtztT4GRL2C+DY+bSI2ZpZXn
wb/MG88Q00OZi5qQaHR2V2/fT+0V93xCgx+YLqHEei22Y75tQxgbujzXnzlOYjrn
jju3au81Fks=
=gkq1
-----END PGP SIGNATURE-----

--=-auuee/X1upD+bQMYrTHk--
