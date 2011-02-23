Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1BWPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:31:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43827 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1BWPbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:31:23 -0500
Date: Wed, 23 Feb 2011 10:31:18 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/5] have smaps show transparent huge pages
Message-ID: <20110223153118.GE2810@mgebm.net>
References: <20110222015338.309727CA@kernel>
 <20110222015345.BF949720@kernel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZInfyf7laFu/Kiw7"
Content-Disposition: inline
In-Reply-To: <20110222015345.BF949720@kernel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZInfyf7laFu/Kiw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Feb 2011, Dave Hansen wrote:

>=20
> Now that the mere act of _looking_ at /proc/$pid/smaps will not
> destroy transparent huge pages, tell how much of the VMA is
> actually mapped with them.
>=20
> This way, we can make sure that we're getting THPs where we
> expect to see them.
>=20
> v3 - * changed HPAGE_SIZE to HPAGE_PMD_SIZE, probably more correct
>        and also has a nice BUG() in case there was a .config mishap
>      * remove direct reference to ->page_table_lock, and used the
>        passed-in ptl pointer insteadl
>=20
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Reviewed-and-tested-by: Eric B Munson <emunson@mgebm.net>

--ZInfyf7laFu/Kiw7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNZShGAAoJEH65iIruGRnNUYwH+gNDTiqWFnERc/nD72V5k8zj
PEd9BqE0XqfyfXAaIySAgT6JfWJzlDG1zumNHNPXbtvHgSIn/5V92I3o+WIm2Jpi
7n+wxcFt9q4D5DDqa9BsHnr7bAANe3AjKjA6+yDET3dUlQpfPFG2iMvDCQ0V3mPk
Mdr7a6ZSP9eMVcZKkE2V+z/M3PO84qT7Qd3j7e8GGKY35fQocHlbvKsPGu4sicGg
v1sRHr/jtH/NyrEE5xhVvgskVbj4pcgyMKIxX/0uVU5Yq/Dc2LIjkF6ZYl9sHnIt
qA4lVAbNxaOtYsCWE39hT26VgmC/72IWmolhRTk7A6tDO+E58ipodLRoMNYwxhQ=
=Pyxw
-----END PGP SIGNATURE-----

--ZInfyf7laFu/Kiw7--
