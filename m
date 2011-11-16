Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1KPWvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:51:40 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:47544 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1KPWvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:51:39 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrei Warkentin <andreiw@vmware.com>
Cc: linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Date: Wed, 16 Nov 2011 23:51:01 +0100
Message-ID: <1472546.S58to4y67R@donald.sf-tec.de>
User-Agent: KMail/4.7.3 (Linux/3.1.0-46-desktop; KDE/4.7.3; i686; ; )
In-Reply-To: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
References: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1698982.ypUGZYjyn8"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1698982.ypUGZYjyn8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Andrei Warkentin wrote:
> 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. It
> does in case the argument is a variable but in case it's a constant it
> behaves wrong and returns 0. Probably nobody ever did it so this was never
> noticed, however net/drivers/vmxnet3 with latest GCC does and breaks on
> unicpu systems.

Obviously correct.

Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

--nextPart1698982.ypUGZYjyn8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk7EPl0ACgkQXKSJPmm5/E55MQCfSLK88YCJLSyuE55U6k2RrhXF
nRUAn1xuXFp5K7T7/C5J0pgru8faZA8I
=zTiQ
-----END PGP SIGNATURE-----

--nextPart1698982.ypUGZYjyn8--

