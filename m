Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab2GLOd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:33:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:13113 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab2GLOdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:33:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="167260923"
Message-ID: <1342103878.18274.98.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/3] fs/sysv: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Date: Thu, 12 Jul 2012 17:37:58 +0300
In-Reply-To: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/lgSVVuldUMOdZaL+D2e"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/lgSVVuldUMOdZaL+D2e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-03 at 16:43 +0300, Artem Bityutskiy wrote:
> This patch-set makes sysv file-system stop using the VFS '->write_supers(=
)'
> call-back and the '->s_dirt' superblock field because I plan to remove th=
em
> once all users are gone.

Hi Andrew,

would you please pick this patch-set as well? I also sent you an update
for hfs and hfsplus file-systems today - found a bug while doing some
more testing. Also, I sent UFS changes today, very similar. Most
probably no one will reply and I hope you would pick them as well.

Thanks a lot!

--=20
Best Regards,
Artem Bityutskiy

--=-/lgSVVuldUMOdZaL+D2e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/uFGAAoJECmIfjd9wqK00bMQALMtYXKdWMQWVUlfH0wmLeZ3
jpomk4oMoRGr5gY2E7ZWHBCD6MU7sOtfxrghZwn1NFtagNdFHxY/NUBh/wa2VowL
clLlmX0BZMijHuRTwh1KFI21A2Kvm5A5AD72gdlfpk6O6+fBI1WJeOHJVQDl4lGv
262ZGS8Yat5yV8xCjwJ7GoNvWtPI1X2sy9TMaLpAZ/6o79lDPRjETIdMg2dxQ2bF
UO8Nyibh9AODtfxBzjRDIjWtN2Ou1O621Vo+p+a5Vib1y9atG+PBTB5CdCcCWW2e
LP49kbKkjemGEcgQ8kMh7z8bzGSC58MO8Ac/rHQXCqqPlWp0rwr92hXjCh4jcCIq
Bg7jEoxMMseKqPhS4dAcNmajRAxwaYiMh0jfpN5a0t96gV2HRoDG61c4prQyEDuD
Vt50vKWJujisi9oVtuYZmjNr9VW5TZc9wJxhTXqlQtVnu1hn+yLHeHkKibw9EUTX
fG/dOzKN4kyv598R2bIC8QeW95yb/YVoNtUGi5s0KgyNGXUKBmoqvJCjP55SKR/l
hO+5PGKqGmisO9lrfGP36+GnvTscQTFgYwgbpP/wow6GWwPP6DEP2DFgX01nhaHo
QpvPQtyHwyQXGXSiDfqM+rj4Dkn3onnFH7lw0U3MR9iraVq0A7zoNYLgfkmiOScO
wdN5QKJVuALz5I146uQJ
=6N1R
-----END PGP SIGNATURE-----

--=-/lgSVVuldUMOdZaL+D2e--

