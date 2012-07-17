Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2GQJrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:47:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:41199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab2GQJrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="169302658"
Date: Tue, 17 Jul 2012 17:47:59 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: tony.luck@intel.com, borislav.petkov@amd.com, peterz@infradead.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] tmp patch to fix hotplug issue in CMCI storm
Message-ID: <20120717214759.GA26517@gchen.bj.intel.com>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
	borislav.petkov@amd.com, peterz@infradead.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1206181422420.3086@ionos>
 <1340086140-13652-1-git-send-email-gong.chen@linux.intel.com>
 <4FF3FAF9.4060302@linux.intel.com>
 <50038790.6040707@linux.intel.com>
 <alpine.LFD.2.02.1207161021130.32033@ionos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207161021130.32033@ionos>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 16, 2012 at 10:22:16AM +0200, Thomas Gleixner wrote:
> Date: Mon, 16 Jul 2012 10:22:16 +0200 (CEST)
> From: Thomas Gleixner <tglx@linutronix.de>
> To: Chen Gong <gong.chen@linux.intel.com>
> cc: tony.luck@intel.com, borislav.petkov@amd.com, peterz@infradead.org,
> 	x86@kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3] tmp patch to fix hotplug issue in CMCI storm
> User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
>=20
> On Mon, 16 Jul 2012, Chen Gong wrote:
> >=20
> > Are you still care about this thread any more? Any plan to update it?
> > Hope to get your feedback ASAP.
>=20
> Can you please collect the latest series and send it to lkml, Tony and
> Boris. I think it's ok as is now.
>=20
> Thanks,
>=20
> 	tglx

Fine, but what base I should use, -tip tree or Linus' tree?

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBd2PAAoJEI01n1+kOSLHB+kP/iGAWz6E/k0MtHoyyYi3vuYj
OE2bfpHz3/8y9kBD83qBfPeH9bRwHidbHxAfrfiDYPuYkzC3Vxr3tvf3EKJG1Hv8
ksKKUxyA3mHJvj85YiGJooJWOVYrW3iO24Ypm/uazec/50rVQxbV2LVInOHnTEcQ
kshvwwWE3NxBf0CvqlIRxfyh/dXUwC3xaNmyuwdAyYRzBzOG7W4QFz4kF9W67TWn
coD0La3b8wuYTzFz9BNYgeHoLi+jam4rphihTH2EB1gprnuBB3k8pZyNqjmE4qic
b2gH/vmF1nUw1NA9tZyYeIyosXRQSm27Cuf2fcOB4kqcO54Av1S98N38VIwqBrts
Vqkuizw6e3dl7ScI8U+LwHPpw80KXKpO19YUTJrccZTSqY8axQGsq14PP+lk5RVj
ui461wIEz1jAs75qv6b8FYb5FMEbWNIhnJ+m30NEsyDR1S+8hW4Cn9/H9MAWBGT7
IoiVwKZ+UUwCNkTcHOLgiONoOsg7LdJhsfMo565ZM7PByUTeouk3keBnXa0g6yI6
vDhOf1PVHdBh3A1j+R6/Ow7wq55gseGSkVv8oZNfojnoC02/VQha7GKzBjcYgcfC
uXVbMRPq9ZqDAPKZ3tlmhAESfnlClxXGHa3IITlJYD5DSW4CpLOB9hiO0LQ25KVV
cJTclDaEbBu9WtO6drig
=fW4c
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
