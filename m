Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965864Ab2DKXai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:30:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:54358 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965850Ab2DKXac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="140654514"
Date: Thu, 12 Apr 2012 02:30:45 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>, jim liu <jim.liu@intel.com>,
        Jackie Li <yaodong.li@intel.com>, trivial@kernel.org
Subject: Re: [PATCH] gma500: Don't needlessly include version.h in
 mdfld_dsi_output.h
Message-ID: <20120411233045.GA16184@otc-wbsnb-06>
References: <alpine.LNX.2.00.1204120002390.2137@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204120002390.2137@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 12, 2012 at 12:05:29AM +0200, Jesper Juhl wrote:
> drivers/gpu/drm/gma500/mdfld_dsi_output.h does not need to
> '#include <linux/version.h>' - so don't.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

--=20
 Kirill A. Shutemov

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhhQlAAoJEAd+omnVudOMcYQP/1Mi3ROiaZK/wP6MmT35k9f4
/33boHNSRYZst6sN/CMezQ5vTcGwHBbdMujlD7ED8ARcQKWVNDhH6lC3WsJPMG4k
9G02Y3EyZQpDX/XHNU5fEJJgCOLoa+BW7ODYFdduYjyFrelxl0P1uxE/RrIx6NPD
PPhX40uYn870y2TnTT2SyG0WtRJ3LDcIOXh83fGsSJo8/q8OC40WCvkPqUC5HWKV
pryL6CXYeJpfVQRULQ28YrU2PatZuxRM3e7rKKsL/JohigegVEd9Cia5KVeSil8p
GJgmwNSvYYbLJ0qi/pNxPXMVKrwfeIqJp5F72IaaoRhtl/IvejQbm4vZjJpLapxr
mJIaCBxU2g8Y8WOy0SPDqtaD8LyKkc4q6HzgoyYJSOqPc9DMKPtplIMRJCxVAoFD
GFXQbyvZR1knzI41Tcw5scGbqX7TQIuGgSBSZFjPYn3TubqyXqbIMjWRrxAxp7nU
YJEilI068+80PyTPOayQ7XueV7gDOGgffqxFMjLHLdiseoV+3MixkqXB2s3U3MhM
zmbupbE40Lw3vsfk/kWVbGxXi5xvFn1q0LsSyEs04DTNtgnNMlTLkWij6f1BX/xB
MIX2u/6ZexWQDYngUlLn4E7qn7Yeopwcr4/7RS2HLWRe//KEMPSzMm/V8MNt3FNC
bmqnbh6LxP08X/t8ZPqJ
=SwWm
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
