Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2GSDlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 23:41:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60767 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2GSDlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 23:41:39 -0400
Message-ID: <1342668949.16745.0.camel@brekeke>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad
 PEB handling
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 19 Jul 2012 06:35:49 +0300
In-Reply-To: <20120718225537.38ddbb60@halley>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
	 <1342607317.7530.9.camel@brekeke> <20120718225537.38ddbb60@halley>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-CUBNkJ6ZnSDhiF3VUZgm"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CUBNkJ6ZnSDhiF3VUZgm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-18 at 22:55 +0300, Shmulik Ladkani wrote:
> However, if you DO NOT mark it bad, but instead go into RO mode, you
> should be able to later re-attach because the good_peb_count would fit
> (no shortage of PEBs).=20

Yeah, you are right, I'll return to the original patch.

--=20
Best Regards,
Artem Bityutskiy

--=-CUBNkJ6ZnSDhiF3VUZgm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQB4CVAAoJECmIfjd9wqK0+8sQAM4yQMGpLP0Zbj7tRy1wwZKq
W5fk5zGDYDdCVJiWtDy80C4RPoKW4WfPIzrJAYTszeDK3BAkkAI+8cW7go0wgJFF
f+uy7nPLFYTSP07LzPSufk7ODGGMdiFWjcLT6BKDRLbv9uUd0cyLWu/z9dw+mgdl
f1Xu/APekLn/5Ydy+9yHQIEmCRVkrEbEKi/NF22K+A3xE/6U0HTSkZcsoR8Osnlc
4gKdib1gL38AJldasd9UMTUJt+C9YgNZzJHmgfL3W2bhdAnRvez7xhAVGE+9xarT
watcSgsvmXdbKk45rWhGYZH4hQVtXUC3dD05O4P5AhSZzJgq276gu7HeZSw7uir2
z6hgbJvIx5jx/HhkmQeisGM26QpvgvVl68IPAN26puTda5FU+fK8HFS54J3QrSxz
vRtuZW9Kx/uhG7KU+sJhJ800xNatl7vaRMQfhzXadbruXxAtxEJPV0xE6yBPON3N
44+dG9QAcFaTuQqFoOzI6kwv8vHDl0qnkfvggbZ4cOME8Y5u9YdkMoLx5IMKhY2P
gQImafXtYkdRltg/0JYJcbCurm0+eSdQeH1Ohl3dPAV5fxZyCkQWdbEDbnyVRD26
UqGRbTA1Ly8q2NncLZh0nMVwzlgMXM9ohF9HK8zhGYvECUOpbFtDx2nJTNB1uGSS
Yfav6Rmv3tdGpXByCECq
=qFMP
-----END PGP SIGNATURE-----

--=-CUBNkJ6ZnSDhiF3VUZgm--

