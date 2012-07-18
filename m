Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2GRNHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:07:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36005 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2GRNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:07:39 -0400
Message-ID: <1342616525.7530.22.camel@brekeke>
Subject: Re: [PATCH] remove invalid reference to list iterator variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Jul 2012 16:02:05 +0300
In-Reply-To: <1341753582-3943-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341753582-3943-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-W1ZXQZNbbYwATuKYkB/h"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W1ZXQZNbbYwATuKYkB/h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-07-08 at 15:19 +0200, Julia Lawall wrote:
> If list_for_each_entry, etc complete a traversal of the list, the iterato=
r
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.

Thanks Julia - this one is very useful!

--=20
Best Regards,
Artem Bityutskiy

--=-W1ZXQZNbbYwATuKYkB/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBrPNAAoJECmIfjd9wqK0vSQP/1sK+Khr5PKw7rAu0dY8QdGz
QwLgLJ/+9ghWSi2KB1hqjxyUpMgKF1t4mIuh8VjKyCPVQqe2btm5+L4ke2+6pNvE
wMDpZopVMk+IlrGVydKUBL/PX/MguHtPPgqSPXfC/neAjorptia1SphytNY8mLnW
k/q7GxLPwUkeym9aCTY/JNUfiR8I2Z4kL+riYfkgIL90jTbNvJXu4TLBqdiLxwiL
TorlnBbNc5d3rAC5CNmGgjZWrPvtEqhv90Nkgb/gb3DozGsYN5nFMpsLph4vgcG8
sSoUJN0zd9k0+wXmVg8NnUuBGWOorp49MO694uL1BmT2wqoeQq3KTZA2WoZzeDZU
/L0dcCz7wxBRfCdfCwjeQjvk5E/74eRlwcnbtPMz1YvhSiIU5AxqgJEFbkwmK1pI
mL4xQV2/9YLvAQnxQuMaPGJxQQupFDU9kVbn7uoF6sb2RY/X3gQSVukiJ5bgT21E
gX+FsHAOseZ8XfVKxrmC7XhPbVhTtkENJ7W6NMXakreK+ALCXzAKmhbLIl8kj9JC
j6wpr2DoCThR6Qhtsi8ebPrAAZmjt8WN8ni/PxXwjA3lSFqIs+k4ERJJdtjFZPCv
NQ714ftunLxmsHZoPUMXmDwSqFlSLOdnFsHrqNCG1dDYx+35rf3r6PDg2ywOgI+l
rQ/i8+hfnknDX0hK6QDL
=vjnG
-----END PGP SIGNATURE-----

--=-W1ZXQZNbbYwATuKYkB/h--

