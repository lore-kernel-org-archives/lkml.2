Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2EUJKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:10:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44456 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab2EUJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:10:11 -0400
Date: Mon, 21 May 2012 19:10:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-Id: <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au>
In-Reply-To: <4FBA0460.1070300@linaro.org>
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
	<4FB9F818.4030801@linaro.org>
	<20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
	<4FBA0460.1070300@linaro.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_19_10_07_+1000_OiW2hqbx4Co=nRmL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_19_10_07_+1000_OiW2hqbx4Co=nRmL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Mon, 21 May 2012 10:01:20 +0100 Lee Jones <lee.jones@linaro.org> wrote:
>
> That seems broken to me.
>=20
> Why would any of the X86_64 systems be building ab8500-core code?

Because the Kconfig allows it to ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_19_10_07_+1000_OiW2hqbx4Co=nRmL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPugZvAAoJEECxmPOUX5FEadIQAI2/GXm92bkN9oH3XkrivGwa
sqmaP1YOcSQKIvEmHKjjRm4iWtB4+uP8uKdHmwC59OjdLostbgh4oenCSX87cTmH
TjpokTw4+1Ttc75bw2V9WMJnm+qYyz56wi77Ck2QjS8Ziheffmi4u1rM3O5cUtPI
Dz6MTM3FTCvvCKMfGCgZqxGnwEh0ik6mt4BESnC4Lj8/wN6fz9AOVPJ1NFNBVSed
UL/NmKj1sCVPHCmaCVRDw5IOOkD/uDtVW5iNOBvgoCOrxAp3A89WdlLOpVenRv0C
LV+3C7ewjLXlRr9sQTqEHpp449maVOuTQrJnuuvHqU4eNgMuY3rjm+sQ4nJ5QOKd
+C4ZhSZZPYK18sPQAoeBVBdxejC+CreaDREYFtXxzdQD293aG2WwN2fKZZfw2qYN
V1Qnrksp/ZGN1o4o4/YK+AZYiastzk0g0tMiGQ4NFOH0qG1Vks1ef/7U9lY20mj+
6yOHgY2SUmIa/Y/VJ5LZeflf/nSRMEPTwLMZzNd61LxXE6ULZ/K7TeF6gyos0/pv
O1/NvnAmeTIDJ6vVmWpd6wgK5RIuWKoumldu+sfGYgotgs3hQS8aOIwnXFVexPRo
EJS4nnVJZLqngRCRiR5xBNmTnLHo5oPGvOLoT3po1SxlP16uhz+2gUXVHZI5JUNH
VDJGmHEdMkk+aQlZZUSi
=fI67
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_19_10_07_+1000_OiW2hqbx4Co=nRmL--
