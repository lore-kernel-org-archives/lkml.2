Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1BWPeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:34:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63049 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1BWPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:34:08 -0500
Date: Wed, 23 Feb 2011 10:33:30 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
Message-ID: <20110223153330.GF2810@mgebm.net>
References: <4D6419C0.8080804@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <4D6419C0.8080804@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Feb 2011, Petr Holasek wrote:

> When user insert negative value into /proc/sys/vm/nr_hugepages it
> will result
> in the setting a random number of HugePages in system (can be easily show=
ed
> at /proc/meminfo output). This patch fixes the wrong behavior so that the
> negative input will result in nr_hugepages value unchanged.
>=20
> v2: same fix was also done in hugetlb_overcommit_handler function
>     as suggested by reviewers.
>=20
> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: Eric B Munson <emunson@mgebm.net>

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNZSjKAAoJEH65iIruGRnNfmgIANcaLoAQV6ayXUnWTeYd1BtW
xjf2c91jcxg+UMRNmpZEkQXVU03CfV4GZe/o9r1vXDTZTtUgMYpRcI+dhIC7X4+W
IhiPQAB1I/J0E8vNvYfbj7J2GK7vvmMhM1du3DQyb44L5IsbNiaA13VfCrUqTS+g
3Ls6SROHpQOc/Qf4EXsq0w6nrrlJfOFajLJ7LNA6EAd59Ze6mA0QaBrARyOmpjYe
IPQZbPB5IKcy64+1rnTjrDgd9ba1ruhOKVsrb0q0u7z1LO7a+K9IhPMVpPNkydeS
8bHUWdQCnH0NdHkWggTPdJac82e5JGWddcjoNi5JYx5/QqNLkWqIgVDA+kXg3hQ=
=QDU0
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
