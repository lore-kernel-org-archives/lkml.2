Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab2GZJTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:19:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:20033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2GZJTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:19:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="171651612"
Message-ID: <1343294653.4060.248.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 15/16] gfs2: nuke pdflush from comments
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 26 Jul 2012 12:24:13 +0300
In-Reply-To: <1343293812.2720.10.camel@menhir>
References: <1933132989.2570662.1343229366388.JavaMail.root@redhat.com>
	 <1343293812.2720.10.camel@menhir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3OVN0ydE8rrhl9Y3n+9Z"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3OVN0ydE8rrhl9Y3n+9Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-26 at 10:10 +0100, Steven Whitehouse wrote:
> That ok, I spotted it anyway and it is fairly minor as patches go.
> Artem, do you want to keep this patch in your series or should I queue
> it up for the GFS2 tree? I don't mind which and it has my ack anyway,

Hi Steven, thanks, I think it is better if the whole patch-set goes in
via Al Viro's tree.
>=20
--=20
Best Regards,
Artem Bityutskiy

--=-3OVN0ydE8rrhl9Y3n+9Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQEQy9AAoJECmIfjd9wqK0NzYP/2ThJKK8K2v0DPcbvJOtwbBa
jMGIrkkmU1O6IJ8P+XQSyRqAAp1w2mA31/Ol3w1vVZZEZL5F/vYZzqnz9feRAKvV
2chBKI5InuSrmgsaqkCeaKkef068S0N8rwsjxVcDSnUzzr3EtE3S8eRXZrUWc6NL
J1PfKPqIhla+vabQWmlCQaDTMVI7p0vDzTMz5++SP70kZxneVlhRrRkGD4WB/avf
xB70/JtGKB859RBVWjLrgVzScNXcqIweOTMc/KIYAWtjd+o14tIzxxPkSCv7GCH3
VSzmgEwnwCW06LdiilBttdBiAxh1PleCUCJxjGbq5tUg9cmskgLXz+dKfq23GLs1
NeBi7wwT8i7MwkNGmI5Py0vO569b4JtEzYrpkvQMB2g3e88s6t1cLgmJxh5HllJQ
OA/8DY0c+UspmlZdGggbjSzHcQcxryAhUWQOU8YVnXZPKvUdvQSNfEE8AWWj1U5u
H5Jli1bx16/oDPF3VNNVcT60XSJcXKmxdK9Gm1Dhu+nX++PgcKxSQ1wZmCIvB8Dc
kyGyBuW220pfDXLNDqh7DxHaXhDmwo5R72vVAEbEqjbbJ2Q7xbaEO37EJ0q/l+Uc
dspJc/Dcscdtg9F43Evx8RUOzdXeURQ/YuJuiDfYdZB8qb+RKjQ4zWTRkAr4crI4
ghLxT8kSR0Otx63VUC4u
=O9od
-----END PGP SIGNATURE-----

--=-3OVN0ydE8rrhl9Y3n+9Z--

