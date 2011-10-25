Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1JYIpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:45:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33105 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab1JYIpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:45:33 -0400
Date: Tue, 25 Oct 2011 19:45:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the moduleh tree with the  tree
Message-Id: <20111025194519.de13df739f60f9d961425558@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_19_45_19_+1100_Ln+s9IfXas7+OFID"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_19_45_19_+1100_Ln+s9IfXas7+OFID
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
arch/arm/plat-s5p/dev-tv.c from merge fix patch
"arm-Add-export.h-to-recently-added-files-for-EXPORT_.patch" from the
moduleh tree.

This file has been removed, so I dropped that hunk.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_19_45_19_+1100_Ln+s9IfXas7+OFID
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpncfAAoJEECxmPOUX5FEhW8P/jb/rUhZeNqUKWTYaFElRw5T
3esek64eX6bho67kWxF31iiYB6fNuIjzcFNBYQOzccCGVa13Yw//gpdmdpI1cuk7
drh4IeYSiL8vl8q1YF+jbaO8+fAA/AYkhSGxDvmAoYidJBjUw1HOkYFItLVAPoQj
7Vz7gnTevxevY8+S+if+yW3IpmVu5FGnNXo07aVWTnOKH+ch4BGBADmFqEitt2EM
CoQoKXzkpIU1HyS+DSbT7iDEtseRXQHiBciLk8Jhyfjc0xGqRmsOBcOrXX/RPaTn
4M4DvubfwQjqXTzUhyVgVHDgVrDZKAMQet7q+nKcfsXjGER6/tCFC+o1wL4Kw78F
OhH+Z00RmTqk+PsVxZw1WML4+vaXq8mL8M3bmvBGxI73r3UrMXM6kmKFcMmBizh6
UrsxAbYvawZdJqW9my+FsobmaIFtqNisaA/BkOH54oqHRW2eB7ZoL2V92/I2xA3z
xYfjCdTj0wgTTzuwbw8VkCNZC9ZJhnCtkcsDELRayB5WAF1XNCFY1MzjVSLXWP6C
gbW7y3Q/meBahG9b6qHfEFmN8jQ/5FZvVlEAbM+bGd2IhIbetSQZOZnwo6HXGVzt
WEyAijMYTdFwBL/VnKS7lqm1DoXlsv5DCEN1lFH4KAk24ASHGQrdJ5ZPVfe/UMGP
obzN6v32WQXtxbUgBk9E
=A2pr
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_19_45_19_+1100_Ln+s9IfXas7+OFID--
