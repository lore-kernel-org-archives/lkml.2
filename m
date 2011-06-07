Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab1FGSFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:05:46 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:52309 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab1FGSFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:05:45 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Maxin B John <maxin.john@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dima@android.com, willy@linux.intel.com,
        segooon@gmail.com, tj@kernel.org, jkosina@suse.cz, tglx@linutronix.de
Subject: Re: [PATCH] mm: dmapool: fix possible use after free in dmam_pool_destroy()
Date: Tue, 07 Jun 2011 20:05:33 +0200
Message-ID: <3838457.LEWxWdrTRM@donald.sf-tec.de>
User-Agent: KMail/4.6 beta5 (Linux/2.6.37-12-desktop; KDE/4.6.3; i686; ; )
In-Reply-To: <BANLkTimYw-WAK3Hd21XQWrjBn_1+wRMzUQ@mail.gmail.com>
References: <20110602142242.GA4115@maxin> <BANLkTimYw-WAK3Hd21XQWrjBn_1+wRMzUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1413092.VXQfqmDd7c"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1413092.VXQfqmDd7c
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Maxin B John wrote:

> Could you please let me know your thoughts on this patch ?

Makes absolute sense to me.

Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
--nextPart1413092.VXQfqmDd7c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3uaHUACgkQXKSJPmm5/E6dUACgoXEdYs0c2uDWctkpQRSm5IVR
OeoAoJEQ9gJhrNKozle8sQMgKuM3qZUC
=e+0O
-----END PGP SIGNATURE-----

--nextPart1413092.VXQfqmDd7c--

