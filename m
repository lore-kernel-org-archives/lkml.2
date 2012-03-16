Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030613Ab2CPMsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:48:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:47767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320Ab2CPMsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="118321816"
Message-ID: <1331902271.3730.76.camel@sauron.fi.intel.com>
Subject: Re: [patch] Remove notion of key schemes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 14:51:11 +0200
In-Reply-To: <alpine.DEB.2.00.1203151545410.26775@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <1329152067.22240.214.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1203151545410.26775@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Sig/7iVrSPtJ51bG1RyB"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Sig/7iVrSPtJ51bG1RyB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-15 at 15:48 +0100, Joel Reardon wrote:
> +       __u8 padding0[8]; /* Watch 'zero_dent_node_unused()' if changing!=
 */

Also please, be consistent with overall UBIFS coding style and comment
fields at the structure header comment, not near the field itself.

--=20
Best Regards,
Artem Bityutskiy

--=-Sig/7iVrSPtJ51bG1RyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYzc/AAoJECmIfjd9wqK0FHYQALYK8W6S+J+BB6VQSQAnZ59x
/HB8OOxzFmP9ZQ+3X56KTH4aoGYZdIb8NxdEl2DtKfearOxQDXIr2m0wH+V5TYO/
4+s3oYxAKgS/i+QMCxZ5sMBATxQAyyW5LgRciFPVJJ7zBIQLsItU+NcI1PMHzBWb
3JVP/ORZMhthFRmB/+FfRVOv0Qrk5i+1q5pUYrZmI47fJVttMltkEYLF5XVMft+x
EWzr/K9su3fuXVw4R7sPh4AvVbTcC6yWEEQddW1N80pdvuZ9Ife+W81nHehbqZu5
66zuxaT3ikGYY5QchsLJ2L2MNbpT8lu0wBdDnjxpcCteOfIoRGsrpEq+MWdaaFNV
Sl1H5qaDpYENnsevR6Gu7XiZCblkMqrpNR1nzVCK8hO1M7sEbwvlmUd5QIxMLTbP
DzmrE7753A3YiQjc7sn/llsThqCdJg+Uq86y9ekzNULim7iU0KACOU6WL5rJ4PYo
3BT4P1F3azf9yhYpGDovMiXNJ4YbBRRCQQ9XzZsoGvqwIRbs+mW9RpSdz0NX4K9Y
Z7WxLb4qRYa4ityjYgLrHs4ALTPXrfUN//JmgfkptZZbxNcDTunmNtXDrVZieqH7
Wf61bqwHBRChJ8Cj3NklGKBwFc8mkZdz7KkDgFvv7F4XGKzXI6JINHe1cvF+lyWm
X0thRLlX/NUG4A3mbjnq
=cJId
-----END PGP SIGNATURE-----

--=-Sig/7iVrSPtJ51bG1RyB--

