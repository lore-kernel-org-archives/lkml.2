Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2F2LDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:03:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:58665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2F2LDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:03:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="186563056"
Message-ID: <1340968069.3070.148.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] ubifs: Fix build warning
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 14:07:49 +0300
In-Reply-To: <1340657269-8588-1-git-send-email-aletes.xgr@gmail.com>
References: <1340657269-8588-1-git-send-email-aletes.xgr@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jxI3kNP2xoremLEeHj8C"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jxI3kNP2xoremLEeHj8C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-25 at 17:47 -0300, Alexandre Pereira da Silva wrote:
>  #include "ubifs.h"
> +#include <linux/compiler.h>

This is not needed, I've removed this chunk and pushed to
linux-ubifs.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-jxI3kNP2xoremLEeHj8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7YyFAAoJECmIfjd9wqK0mkMP/iE4463WSYETj0SxmddII1k+
9j8z6iZdM0lRPIlzIjUnmjB6gsmos4pGIm4aLltd37k2l+jlw1WJ2Bdh1k0480IC
uf1WVmTh/8m8nJh0bm/ctOygoxqcNQjUj6rGFHK6DBk6qPJ5yKnM6GeZ9z2kNqpF
F+8cP5n2a05mWqkmGwijJaFcbqhOJEKJgaT9y3t+bKPaYRbBowCj25MHgL1HDX0T
a9yQiOw2/WPDcj/0FOdEe0MSN96sM/H99m2YzegVH3tv2K4zu8DpQby+C0S5x44d
kUmgpeUHAXbtAiS/Z22fd5cgRYBZlER9A7gW9M0RaHzhPxK8D6wll2LOn9RqFQEO
nwH2iSc6IeHQKHcg0iIasMzD9HrRwu+fjuQgNTMVqKmDydtCt4WVoWbrKX9aIGN3
UgiwJUeo4y/QXaf8fV+9G4UpPbQo3BvT04o128V8NxcoUm1DYFdZacNjwUwP1zNX
mEW7WBy5qPadu8+SfGYA9Kv9PVsaMe1mb943RfTKxU9PsgMcQiPi7ieZRyGTkd5j
jMJIithaSV0JK6EQ5jMHyMUZc0j6bHfV65hmZhmtW1jPpeYeOQHyweulkqwf5yvH
EeTKB3JAutGu3PoNo21B65SyxpkWn+TxnSC9ryjb5No+vdmfanYwUUXi777auyj1
VJDyubZXLDFPSxP611PM
=ve2X
-----END PGP SIGNATURE-----

--=-jxI3kNP2xoremLEeHj8C--

