Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030747Ab2CNKwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:52:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:52389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab2CNKwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:52:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="117571730"
Message-ID: <1331722485.2140.13.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2012 12:54:45 +0200
In-Reply-To: <1331656495.11405.4.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
	 <1331318968.13055.8.camel@joe2Laptop>
	 <1331557935.12037.11.camel@sauron.fi.intel.com>
	 <1331566415.13200.14.camel@joe2Laptop>
	 <1331570150.12037.55.camel@sauron.fi.intel.com>
	 <1331572270.13200.30.camel@joe2Laptop>
	 <1331642368.3595.31.camel@sauron.fi.intel.com>
	 <1331656495.11405.4.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lt3GobaZ+kZfrCPzqEx9"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lt3GobaZ+kZfrCPzqEx9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-03-13 at 09:34 -0700, Joe Perches wrote:
> These functions are conditionally compiled today.
>=20
> Introducing a bitmask allows the same conditional
> compilation optimization.

Yeah, I know, but I think this is useless and can be just killed.

> David?  as nominal maintainer, do you have an opinion?

But you are right that I do not give guarantee David will accept this. I
can only get this to my l2-mtd.git tree.

> btw: Artem, you are not listed in the MAINTAINERS
> entry for jffs2.  Should you be?

No, I am not JFFS2 maintainer and would not want to be because nowadays
JFFS2 is on its slow death path and very few people take care of it.

P.S.: it looks like this is where whole MTD stuff is trending as
well :-(

--=20
Best Regards,
Artem Bityutskiy

--=-lt3GobaZ+kZfrCPzqEx9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYHj1AAoJECmIfjd9wqK0j4MQAIPSxFBdSANIfWIrYJcflICi
CL6Zo4PZYDZ2SYlYjk7HnCfbPb6jlxmWb/vBncBMmb5qYiuTFoHlcd/AyPM3DYHj
QpHOplXYB9MNFBG2vWiB+DXDIJAqxZrGzYqVJZxpiHFBE3t1cjM6wkNWkRnSpqOo
8hrbs5FqMZepnCBpH3Sv7hSCQ9oNW8wwmS/R2OuuKYV+a9OhFG1mAOmW6yDRswP3
SsQq0GgYdOP08bcTGlreie6EIdeU5aiJGk8tUBAqmwFviwH50NnMbfZoyiS4WRaJ
7lcSCk38czj2Ep6/Ic+59j8+DcDTcjA4fJfkiQvmi3RV6nEMqtHhvAgIjMBrL1WZ
0eG0hzXgObN2wzO04u7pt7hOmznM9wrLlK8sNBmKAG7QTvTzj2Yz+U7JyZY3md8c
0wJJZwuGKR3qNRJDjx6mxvl+beWAx9DaUHR5xpwh1pljRL5uHVpt18YtOtspkOAO
03YttS+ImXmzRCautD59S+viwX5SlmxbsHxJ3PmRY7HCoTMTzIOqC53JvSybc49/
vglVxkj/YCDfHh/vUerpqFxllkdZLdfQTwgWzQBDBiS/NeHmzoVm3YeWQx3I1Pj6
1YEfdQ7/QYIrWwztEUM3OCT9mopnS8U4pQEorLiNU987CO14dKqWaurqNuYTHbcp
X52BT8QjLT7O+OQdTwGp
=TUWI
-----END PGP SIGNATURE-----

--=-lt3GobaZ+kZfrCPzqEx9--

