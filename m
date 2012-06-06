Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2FFIYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:24:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:39860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab2FFIYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:24:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="175394642"
Message-ID: <1338971303.6875.6.camel@sauron.fi.intel.com>
Subject: Re: init: multi param parsing regression since 3.4
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 11:28:23 +0300
In-Reply-To: <87ipf71ytx.fsf@rustcorp.com.au>
References: <1170056063.1844670.1338571611538.JavaMail.root@advansee.com>
	 <87ipf71ytx.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9Wdb7vTTf/2Oa4WKok/G"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9Wdb7vTTf/2Oa4WKok/G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-04 at 14:02 +0930, Rusty Russell wrote:
> +	printk("ubi_mtd_param_parse: val =3D %s\n", val);
> +	WARN_ON(1);
>  	if (!val)
>  		return -EINVAL;

Hi, please, zap this printk() and WARN_ON().

--=20
Best Regards,
Artem Bityutskiy

--=-9Wdb7vTTf/2Oa4WKok/G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPzxSnAAoJECmIfjd9wqK028kQANK+tIYzFrGOgnz/jgBhieyg
0EQbAgCqjbL+0QjX7pfV3M5JGm41iXMjn8ENqKX1o8tGaFFbO/z/WG5BS7GmdFPj
MiZDlloD/6AEEZlvGCgGq4kBG/k2FD614xYczcF6OduCWuXNDI+vZjISCsZl4o6U
YlsFpTwB+VQQEgcT9X40GROaJoQeDFQKysuz19sJ+4mmyCRDH1Rrbzz3OBr6RJHf
VFReRNF/wuh/5hOG/dyfpegKAvPX/DbOHV8tNev3N5C/xpPnpM3h7BRdBpj4H3LF
2I5lFJ17Kxl/4JGJ60RtbQukQkQuSETpFx+44Ojs4QptgFDGHQixIAXXV7Uzl3vZ
YmsL9o5/9f73tqFUyoNR2Gb9b0E5bAG1/1PaU0xRZ4tezxzRuwFlozJvo3rd6W/M
id8BITOSBr7QqPX38wKeQyz7/BEV1+fe3qWeZsN58AD6xtShNCg43nk9gCY3caeS
QvFmr0NivkFh4uTIv3yTDlLo+zdLkSHc7WIW42l4pQZpyuOyzQ96QtEJDOb9DIt1
AvQsXI8vO3h7l/t9q7KSteRaSTW3jwZ+NlURSQUn7nTfoPFQ3+8EkUBHylmZPN9j
2wcased/wt5yiOMxhE4YtVPLoNEC/a+JOZjq/6Y8G2+uq3/fZP5gXdBsJat/fcc5
VLx4hzdVwUJvgYH0wKH5
=iZJB
-----END PGP SIGNATURE-----

--=-9Wdb7vTTf/2Oa4WKok/G--

