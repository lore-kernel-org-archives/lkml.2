Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2AUIXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:23:18 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:19525 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2AUIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:23:17 -0500
Date: Sat, 21 Jan 2012 11:24:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kashyap Gada <gada.kashyap@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dima@android.com, jgennis@google.com, rebecca@android.com
Subject: Re: [PATCH 6/6] Staging: android: Add parenthesis to macros with
 complex values in pmem.c
Message-ID: <20120121082416.GM3294@mwanda>
References: <1327119812-19851-1-git-send-email-gada.kashyap@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/t6ASE28jIy1gGy9"
Content-Disposition: inline
In-Reply-To: <1327119812-19851-1-git-send-email-gada.kashyap@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A75F0.00A0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/t6ASE28jIy1gGy9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 21, 2012 at 04:23:32AM +0000, Kashyap Gada wrote:
> -#define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)
> -#define PMEM_ORDER(id, index) pmem[id].bitmap[index].order
> +#define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))
> +#define PMEM_ORDER(id, index) (pmem[id].bitmap[index].order)

These are not needed.  We're modifying checkpatch.pl to not complain
about these, but it hasn't been merged yet.

regards,
dan carpenter


--/t6ASE28jIy1gGy9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGnYvAAoJEOnZkXI/YHqRT/oP/AmkD9OBZfuAbQfP6hwrZl4U
G0xA5KlhsWh4IVvLA0ri8CFso06sa6yrcB1+7C++k1mREzLiuxxI7I0V8v4oC05b
crBJ3oAtLELvwNrxDuKeBgIM8nVtqO09ApbzskHibw7ZIklbxqqqCWtSxLiQmBbD
8u3sno2e1sV2a7gU00hHbubyyrs5w7xpYfUo4tBlHLplV7qLkoxuOpfp2ncezNbu
yGFVrD3xF9YMJ5Ag6AACHhYKcK8ZSfinriuIep/qcq9PEXo4HUwvVqtp5o4ok2jS
KNX8FgOR9pLEwpBMX0lkCgb0lWF5hnhHlSVMxHx5sL1inT4tB2itwD/o7ZbXxD8a
fnuPw/V680BO91gnNxqbHMuSym6vq9G+024CML1XtBV+5QdQkha4eBbM8h+h1w55
uq+ZrEAQdnkx5blP94VkCp4LvHEWI+bBIij5lA6kHuUsRyiwjxJSamAQX5vGnYRE
RsyjM5tNudPdpf1pbRPUYtLoqv9Vvr2ZMDzHPu8wCvW5lv23awxkuyXW96pXxhvP
a8dyyKj9huyd0jx11OZ4cB6YWCf2jP5hoeWLgggNcqElc81hjwxVzIzZQlp3PPjd
bqmbOWjEj+eww7UppV6auq+4Mzb+KLOHTGdbO7pJRyV50wbYVi91oGRc7a8fEQQA
hK9yQNo2QsU8Q2Wsi2T9
=4j2J
-----END PGP SIGNATURE-----

--/t6ASE28jIy1gGy9--
