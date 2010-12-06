Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0LFWNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:13:55 -0500
Received: from liberdade2.minaslivre.org ([74.50.53.203]:35260 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0LFWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:13:53 -0500
Date: Mon, 6 Dec 2010 20:13:46 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        carlos@strangeworlds.co.uk, stable@kernel.org, ceolin@ulevel.com
Subject: Re: [PATCH] wmi: use memcmp instead of strncmp to compare GUIDs
Message-ID: <20101206221345.GG4187@barata.holoscopio.com>
References: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com>
 <20101206220231.GB1139@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YrlhzR9YrZtruaFS"
Content-Disposition: inline
In-Reply-To: <20101206220231.GB1139@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YrlhzR9YrZtruaFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2010 at 10:02:31PM +0000, Matthew Garrett wrote:
> Applied to -next, thanks.
>=20
> --=20
> Matthew Garrett | mjg59@srcf.ucam.org

Hello, Matthew.

I consider this one a serious bug and with a trivial fix that should go
to Linus, for the next release candidate. I also consider it should go
to stable releases, and that's why I'm copying stable.

Any out-of-tree wmi driver written for systems with two or more GUIDs
containing any '\0' byte with a common prefix will fail to load because
of this bug. I've hit that, and that's how I found the bug.

Regards,
Cascardo.

--YrlhzR9YrZtruaFS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJM/WAZAAoJEEWxSg7udFZIA5EQAISc97mjO2on5MAeiLwqbwW4
kaqSDpzFP9gJWN6UmdbWN/IJnuOewCIbG0GSGue7hlsKunoRLV2QXozUp8RR30F1
RvqdzFwiG6NR/mUSHm1Xmr/L4FyRjbmiz+lr2T57ZfoQA6xrC4H34mIY/dnT2vng
IRj6txmDMijihx6ZI2bYI00hfsgVd64CC/QuaO1dkcPx5kdvBZSm0UhbhvS09Aep
AkvXD1qkFLs6SUg9RKkTcfE90CioR32Qwr7OhXB6mvgqqWrDbg/F8nIKBChZRPLq
letU/6jkFToT+ODReuchY8cvB6V+esXZ8LV0i2/+8Q/tZWg8LoM/dnOrrHZj6joj
mbC4UWVotRRpGyl021H2Hb0OXkIdMhfEnqXsPTeE2J8FTzDXC9AzqZ1jr9ncXM7Q
ZFblvWpyjMCkVnj6Benq9NmsPRgt6QoVRd2r27ismN6GNFLGVsBG3fpNSsE0a7Cz
T9RAC1bvEsV68x52TnzLwHXBhXhyFOLGfq1Cap7Wjr6ePF/CtMi6kI3ZaSX9GKvp
ZWZiNemLyWVFk1wCIg4QkeBiiMLjHyKT+EgmqefsoscP2oPTIhwcHKJacu8gbJhC
9HJXueldKrmYSLt2OERRikGBTJQMRpU1Q9bzRAy3lO7SLDsj0gjdnUX9z+pmYrQQ
4sz5k7AAoAu/EAed7J3S
=b0Fv
-----END PGP SIGNATURE-----

--YrlhzR9YrZtruaFS--
