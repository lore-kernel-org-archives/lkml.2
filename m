Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0KTWjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 17:39:05 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:49842 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab0KTWjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 17:39:04 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 01:38:55 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Joe Perches <joe@perches.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 06/17] pps: convert printk/pr_* to dev_*
Message-ID: <20101121013855.253bd4cd@apollo.gnet>
In-Reply-To: <1290289354.31117.25.camel@Joe-Laptop>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<ce13c55a2acb39be7ef5667467c765595df19835.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120154940.GY13356@enneenne.com>
	<20101121003323.4bbf0199@apollo.gnet>
	<1290289354.31117.25.camel@Joe-Laptop>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/NsXA4TSlbmd28UkOYcGqX18"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NsXA4TSlbmd28UkOYcGqX18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 13:42:34 -0800
Joe Perches <joe@perches.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Sun, 2010-11-21 at 00:33 +0300, Alexander Gordeev wrote:
> > =D0=92 Sat, 20 Nov 2010 16:49:40 +0100
> > Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > On Thu, Nov 18, 2010 at 07:00:59PM +0300, Alexander Gordeev wrote:
> > > > Since we now have direct pointers to struct pps_device everywhere i=
t's
> > > > easy to use dev_* functions to print messages instead of plain prin=
tks.
> > > > Where dev_* cannot be used printks are converted to pr_*.
> > > > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> []
> > > > @@ -80,20 +81,20 @@ struct pps_device *pps_register_source(struct p=
ps_source_info *info,
> > > > =20
> > > >  	/* Sanity checks */
> > > >  	if ((info->mode & default_params) !=3D default_params) {
> > > > -		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
> > > > +		pr_err("pps: %s: unsupported default parameters\n",
> > > >  					info->name);
>=20
> Perhaps you want to remove the "pps:" prefixes?
>=20
> > > > -		printk(KERN_ERR "pps: %s: echo function is not defined\n",
> > > > +		pr_err("pps: %s: echo function is not defined\n",
> []
> > > > -		printk(KERN_ERR "pps: %s: unspecified time format\n",
> > > > +		pr_err("pps: %s: unspecified time format\n",
> []
> > > > -		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
> > > > +		pr_err("pps: %s: too many PPS sources in the system\n",
> []
> > > > -		printk(KERN_ERR "pps: %s: unable to create char device\n",
> > > > +		pr_err("%s: unable to create char device\n",
>=20
> It's removed here.
>=20
> > > > -	printk(KERN_ERR "pps: %s: unable to register source\n", info->nam=
e);
> > > > +	pr_err("%s: unable to register source\n", info->name);
>=20
> and here.

Thanks! Strange that I overlooked it.

--=20
  Alexander

--Sig_/NsXA4TSlbmd28UkOYcGqX18
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6E3/AAoJEElrwznyooJb96EH/1eWvDcGpBjoXiaO8W2lmjJd
wP2ELVPPYsTQGu3h171Qu4uE5EWMDlo5gzM4VxINmlGI3y5nz4ObJfybiNMn3Gbf
m4x34nLa/VX6OGLldMu7gWOwR6St4QNGqy24i8yMadEznpRUSCIeOQ9BVlqxie84
+zuoHP8eJ7QA0fXB/k9q8rFoLaCsgyoiKEs4dnuqic5fv5QgGPNm2o0Z+qkVlrOL
kmW5IIXjU0q7EomYppI+L/SGFgQzvF3kYXj0inA64ZpLqKESXUwjxUoPZxHfMYqL
6eF3yrPuX9PtZghz99mA5DnToLJAPfxuJoQSYvVHksPUuj3ju5jCfQ1tKz16YFc=
=NBVI
-----END PGP SIGNATURE-----

--Sig_/NsXA4TSlbmd28UkOYcGqX18--
