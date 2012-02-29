Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab2B2K7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:59:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37540 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2B2K7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:59:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.208.69 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330513326.3545.93.camel@sauron.fi.intel.com>
Subject: Re: [PATCH resend] checkpatch.pl: be silent when -q and --ignore is
 given
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 13:02:06 +0200
In-Reply-To: <1330364758-12065-1-git-send-email-dedekind1@gmail.com>
References: <1330364758-12065-1-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lFfsmNbQiZalCMEzCnjG"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lFfsmNbQiZalCMEzCnjG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-27 at 19:45 +0200, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <dedekind1@gmail.com>
>=20
> This patch fixes checkpatch.pl when both -q and --ignore are given and
> prevents it from printing a

Andrew, am I right that checkpatch.pl patches go in via your tree?
Should I check linux-next to find out whether you have merged it or not?

--=20
Best Regards,
Artem Bityutskiy

--=-lFfsmNbQiZalCMEzCnjG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTgWuAAoJECmIfjd9wqK0Kp4P/2S7JFMSI9/GfyNelDOTC4Xt
X8R26IOr2jdRZH85Bwm5zt7xAeExwLCl70RWQchkfirgDAWijtMvyuheRDyLdjVR
6MuXcW5bD6oGsNsKFUlYRLmbkS5fJZC0UGJsU1CsYBaHAsHMgCEGewtl2KAIPnRH
OIAA7SL8apFoNcIPHQ3MjRQ0SmAYNMZbHCT/YyGrknDuV0oV07c/uUFDPyUQTKtU
smZhoy9OkaM8j365g01OwDi5RbxjmTue8l6aDl7nBhNcuZKZNboyZWPS7YEhks3s
pNJbGvRSweJy2EEmz3lD6yn5dR2vn6AbhyeJv1NbGkKMlGTYcuSSTsIu2pUQ8ZMy
wPec9IapGKEXWH6F4QkCcK5R+tbs1G/71y8qmA7c+7bTQyuqfDVWx7Ly46T3mW03
sSgeKO6DWGwoK4gFybAa5A4oKko3j5W21IbAQjB+Q9pBrS0HgcmiegDOqj1SFbpo
wX20ei/6KGApcbJWNpXBM2u4lTw3dtArGMzlNy6z4t6WFEtH3cfPx3smOA8+HNRY
25SfqErGhDrltUxw9ePQXH3/PROmOWsD3+vkTbE9C+6tKo0oCtJcb8V8zK0tDP3f
owU29rfS5b67Da3oKAIm2L5ZSacVGcYDC4b17a7L3RoxLMRfhV3tFfl+xmG+8/wR
jg2Q9C1KqfYu0RE007n4
=e3oL
-----END PGP SIGNATURE-----

--=-lFfsmNbQiZalCMEzCnjG--

