Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2BAGv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:51:58 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:34984 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2BAGv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:51:57 -0500
Date: Wed, 1 Feb 2012 09:53:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Christopher Lais <chris+android@zenthought.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add some error checks
Message-ID: <20120201065322.GA24652@mwanda>
References: <1327118181-3542-1-git-send-email-arve@android.com>
 <1327118181-3542-2-git-send-email-arve@android.com>
 <20120121082208.GL3294@mwanda>
 <20120131185228.GA21481@kroah.com>
 <CAMP5XgedsSDtYa-bZCW--+Hj41sN94tDXQ8_d7c4=fT5bJ7mTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <CAMP5XgedsSDtYa-bZCW--+Hj41sN94tDXQ8_d7c4=fT5bJ7mTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F28E106.00DA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2012 at 03:20:30PM -0800, Arve Hj=F8nnev=E5g wrote:
> 2012/1/31 Greg KH <greg@kroah.com>:
> > On Sat, Jan 21, 2012 at 11:22:08AM +0300, Dan Carpenter wrote:
> >> On Fri, Jan 20, 2012 at 07:56:20PM -0800, Arve Hj=F8nnev=E5g wrote:
> >> > - Add a mutex to protect against two processes mmapping the
> >> > =A0 same binder_proc.
> >> > - After locking mmap_sem, check that the vma we want to access
> >> > =A0 (still) points to the same mm_struct.
> >> > - Use proc->tsk instead of current to get the files struct since
> >> > =A0 this is where we get the rlimit from.
> >>
> >> This doesn't seem related to the locking change at all. =A0Probably
> >> this patch should be split into three patches, one bugfix per
> >> patch, unless they are very closely related.
> >
> > I agree. =A0Arve, is this all fixing one problem, or multiple ones? =A0=
If
> > multiple ones, we need this split up into multiple patches.
> >
>=20
> That depend on your point of view. It fixes crashes if you use the
> same binder file pointer from multiple processes. It seemed excessive
> to have three patches for this.

It would have helped you to write a better changelog.  The subject
says "[patch] android: grab bag of random fixes" and the the
description matches that.  You have no idea how annoyed I get at
grab bag patches.

Also don't ignore review comments.  I review a lot of staging
patches and I'm not an expert on every driver so my review comments
are often wrong.  I don't get upset when people tell me that.
Review is part of the process.  Everybody does it.

regards,
dan carpenter


--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKOFiAAoJEOnZkXI/YHqRQXwP/2EAu2+clJHvq7X2f+M3OBg1
fiEHHIAPUEXPB93tFIXLoRbBaPDNbw15jH5GlQpGoMpNdUnH0ZsuEFs1KD64VQbB
HhBC0xlVGJFyX2yjIgKqh9esFyy6SIT/NbES0xPoM5uKw/RY7okS+lLL2AD5MHhQ
KHKH58pGeBYRkzN+/K8Pz5j2I4Z1ultVQLedGjhp/DtZ6ejMUCQoOUXchC2Danfx
AFpnLgCNRCBr1s4FSTJ0cNyom6qBhkANn52LvS9wx8UwPjgIJSMz6qBeCbkLdG/m
piHRhwY8I6Sa8nQykyYWexhsIBMrU2JSMRtEtJZsyMD/oFc79jhxatDUA9hESi3+
PY/9j0OxzaK0bhpzm3v+zV/S2/n2HOZdavsfIL9HkrXsRViyGbp41SgrI3AerSZq
3f4pGEtxpTklr5MNXdRvB5Ip/Pf41s3+8EkgHt/3xx/TZbXQt1P4syz8kAOagtQt
XYW3m0b1NCchJXxpgUhwCWx5PH2FxB+gUKPxDSwmzVgjfE5KmuxmptyGolPlYWDs
AtjAif8m8wGGbPnX/iJgoa8wNRuIXesr+N3sQQu6PZGU12AgSR0B8Vh162YbjKut
d1Jbx40sAnUybZt4OaVEO6qddBk8iljTc+6eEr8W89VOqbvtuUetPbiVPp+fUwlQ
+r4lFAbAe4Cl0X/MjIkz
=G6y4
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
