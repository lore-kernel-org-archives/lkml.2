Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab2GCMDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:03:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:19114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2GCMD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:03:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="160917483"
Message-ID: <1341317245.2979.58.camel@sauron.fi.intel.com>
Subject: Re: [PATCHv3 0/4] ext4: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Date: Tue, 03 Jul 2012 15:07:25 +0300
In-Reply-To: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
References: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QBNAr3tqPeAJbZvc6LTq"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QBNAr3tqPeAJbZvc6LTq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-03 at 15:00 +0300, Artem Bityutskiy wrote:
> Like the other similar patch-sets, we switch to a delayed job for writing=
 out
> the superblock instead of using the 's_dirt' flag. Additionally, this pat=
ch-set
> includes several clean-ups.

Sorry, this paragraph is wrong, ignore it (copy-paste error). These
patches are the same as I sent at the beginning of April
(https://lkml.org/lkml/2012/4/2/111). Just refreshed and re-tested on
top of v3.5-rc5.

--=20
Best Regards,
Artem Bityutskiy

--=-QBNAr3tqPeAJbZvc6LTq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8uB9AAoJECmIfjd9wqK0NZkQAJbaPR7pQx7h84cP+q/4xh5o
ujzpbqjdTAFByooVI7A3PhKzu3V33vm3iYJOOO+5QUMFHp5dvFKMVxToJ0HOmwg8
RnXqKxK/YDeCAlgxXwqU20jMoke36uIVR2sSK/5Gn8EL9x3BosfUtMN+Z2dCYvSn
96NgCygricgLRBK8aysvKA7LkjrSqmaO9Au7y3DSHE3v97rbpnZdejITYcOZtLTr
UlmIgxgIAjrN3EPTTuLi0eFb3ahx+24Jbc6kf1WXwAy3rEHU/CZpJm6RiLSI85ZM
rqr5C0d2xcA4CQ743KQ5BMLufAiTNSl4GO2WtmoqeI/Esqlqj5k+h55JZz9WOLXA
or7SpryBSa1H/7dQjzwfdxdJYHxJxX5E6rN0aKTHAvD/avQDNIxaBVnEHY49frB4
zOI7YA981YiCZtG6KYH7qkSmnGW0EtCpDigAbx67UbX2zJY+2EE347oeCvS+1SWC
4WOSYlmtzvwjDKYpc/2OXiInX9b3IY/bKtkLBfBdWLpacN3/FioOBKdUsYoRv6vz
Ftt76zjf05iSGS+rD6k5ZC9hBsZlrYYVZP5Rw2H92UsAMw+4nssHnGn5GDC1HWkl
c+e0JNUMF7s7oYDFtBs5UUyX+tlFLX+sNZSDin8lNKPvTdkB9dxc6kiWJ+YuqY1T
H2sh4tdReUNheb3awvn5
=Ow4s
-----END PGP SIGNATURE-----

--=-QBNAr3tqPeAJbZvc6LTq--

