Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1CDFjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 00:39:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60484 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab1CDFjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 00:39:20 -0500
Date: Fri, 4 Mar 2011 16:39:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20110304163915.f0b3f60e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Mar_2011_16_39_15_+1100_xnZw8_wpvZ/ysx4N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Mar_2011_16_39_15_+1100_xnZw8_wpvZ/ysx4N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/easycap/easycap_ioctl.c between commit
0ff69fe7cebb65856eba7feb3fd76fb4ba365bf8 ("[media] v4l: removal of old,
obsolete ioctls") from the v4l-dvb tree and commits
f62bc44e055712fc8ccf34654a79137dd4a4d8af ("staging/easycap: remove
obsolete VIDIOC_S_CTRL_OLD ioctl") and
50e1fbdc1c9965b6ddbc5c9900377ff18bbf9ae8 ("staging/easycap: add first
level indentation to easycap_ioctl.c") from the staging tree.

The latter two were a superset of the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Mar_2011_16_39_15_+1100_xnZw8_wpvZ/ysx4N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNcHsDAAoJEDMEi1NhKgbs2GcH/2hVv0pdDe2oCl/CosF21Y+b
8kNIlzFYOFmySi3b0vJfZHM9TP5EsluMZFh7OebtLR7lC4g94SrA11ZyXf37k8Lb
3maalc1qhnhkmwQHT/f603Gcp2pYgTEwwsaT+CrsJcsJX1so9dPWotIM13PMN47i
vpDDdl8o3tZodwuwIeaTvnRSeSVgnrOUWhm4cQUuAjPJcuZ7JOOwFonSeGQvVDL4
wGZbKlgAnLVvK0jyDqMdCjgG3TSZiJZCHzoPkUs2mOKji4gJM8qNZ6CJa4u9n6h4
0/5METzHn7rcZYBGutvYUDBCqruwuLF70fVch+MSAQbyt9sD1Q3jDunQ8stTgUw=
=uuFU
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Mar_2011_16_39_15_+1100_xnZw8_wpvZ/ysx4N--
