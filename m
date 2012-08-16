Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2HPLwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:52:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:56577 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2HPLwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:52:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="asc'?scan'208";a="202616458"
Message-ID: <1345118217.3393.215.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 14:56:57 +0300
In-Reply-To: <20120816112507.01b7c0f0@pixies.home.jungo.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
	 <1345043331.3393.151.camel@sauron.fi.intel.com>
	 <20120816112507.01b7c0f0@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TbJHMDwoAg07MuJYmDU5"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TbJHMDwoAg07MuJYmDU5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 11:25 +0300, Shmulik Ladkani wrote:
> I would remove this one sentence from the log, it is misleading; invalid
> blocks are not necessarily related to ECC.

Done.

> +			if (mult_frac(limit, 1024, per1024) < device_pebs)

Done, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-TbJHMDwoAg07MuJYmDU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLOAJAAoJECmIfjd9wqK0xz8P/3sN6z0CH0BiBaGtq8wzi3Og
8FU+hPxbzokvOETFLZia+HyrLDivk4lhow4yOHMXSkGjZBhn7QJn6Aiv7ow1ULFY
w0KJfxr6i5wEdn4QkUow4cciK3OeMaqTFK0afmZyruVW51wEFh/77cqXUUUKzJDk
oO7OaNECi5YTseCX7Cgcn9IwjqmyLy+kj3M6P4iA9sSsQneRFF1Q1NnX+zKiQQCw
/lxeA+eYJsQgJ8AlCu63Hhztjwbv8fUf38m7eXyOAtwgi/k7czTPQF4LFhwHrrR9
ZVIDGHsPc++XD7kIqTLxneEpYD+Qu0Aizm7PJIKjKUACIHHXVrFGQ0CBhnlAWeoY
DzzydnR9ERiHYBZflJScYwKCNGCaSHkK8wz1U/iP3kuJRtXt/r3ThWVsJi5XTvwy
t1cFK/Wxga/CScfS5puibf2ZCsQEMgs61F7QrjdF0a3DxydXgL9/04AAifPwgYIK
3suqjWlI3HgSb3yE+VL6gHbCe2sGuL5nYtawvbrGVXt/b9e3THlOgm72CQIYUjO1
esjPQAHqwsJBTB/LZMpf7BMtEPJhisdEaoURTiU3AqDJYZNeNOtJLxE6lkMKPaMI
QL/Y0VVkvZ4YcyJsUnziy5HsjQ3uWfHt7cA12rmjWkP/KML9PrjAwyz53qqetKpQ
TYKv2tOJ+e1GEvF+z3ij
=iZjy
-----END PGP SIGNATURE-----

--=-TbJHMDwoAg07MuJYmDU5--

