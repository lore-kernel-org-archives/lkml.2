Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2ATNtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:49:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:53828 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2ATNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:49:53 -0500
Date: Fri, 20 Jan 2012 16:50:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>, greg@kroah.com,
        devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
Message-ID: <20120120135046.GN3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
 <20120118065620.GE3294@mwanda>
 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
 <20120118185457.GH3356@mwanda>
 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
 <20120120115408.GL3356@mwanda>
 <1327066144.6176.27.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R92lf0Oi2sxyK3LA"
Content-Disposition: inline
In-Reply-To: <1327066144.6176.27.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F1970F9.0122,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R92lf0Oi2sxyK3LA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2012 at 05:29:04AM -0800, Joe Perches wrote:
> > #define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))
> >=20
> > That has two pairs of unneeded paranthesis and we run the risk of
> > reprogramming the kernel in lisp, by mistake.
>=20
> I think the outer parens are necessary.
> Imagine PMEM_IS_FREE(foo, bar).another_dereference

That's not going to happen in real life.

regards,
dan carpenter


--R92lf0Oi2sxyK3LA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGXE2AAoJEOnZkXI/YHqRGyoQAK8LA899n4zq1DFeLJgSPFRb
uIjmIyBi6DJoU6iXiIXkxS03zJstukb3xp2+nEHxuFfYssJgFiheLl0msBhR/2J9
KVa/c1mtWpgPAW4PRpQf6r7KXmXr0FcxrhpF7uXwAgAZxskxW5jhEu4emw95MzGw
9E6pa8chVcFGe+UZzLtapSKNs3+BRuuNmoWppVCXyF5krnfnMZPGgcZ+Q++iZc38
bTmBc1MxS8lgzea+JE/gEndISFWNH0z3AhFJ0hhji/wo6E6OChJaqvBaRBoHs/Rz
s5XeMlL3GEwhKT10SKMmDggytoO4ObWO6klscFyB3QCGa3aWP1oTbwkSg5gHr38F
509BoUQ/oAlF/A0pS/2DX3XKDwfg0QqpR+haC51awy1GYCQuOeruokAEF+GC3JcT
TAE89Exe5UtYE01/Hw4JjE44jc6z4y5cfGMoOqAqPklU6lsrOkPf/v+x0nOIIlNJ
S3GIFC33ehazuyMJniBp7iDnprgAQFdKZ5XtMr5D8+7HN5qoReEpxqSI1ngXqf0I
isRiSQ5SDx8NgLMpKwlIWNcufFbgFS3RgQK8EK8WjQ5OBVqcjJftqdXSAKn14LqA
jfreVeow2VFeyjIq28BNq3xKzoyEgRKB1azB070oj0GfujcAq/lWUOsV663FTOx6
rAjm6N/AhK7ouZQ2rge3
=AJTi
-----END PGP SIGNATURE-----

--R92lf0Oi2sxyK3LA--
