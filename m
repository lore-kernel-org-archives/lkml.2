Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2CEHUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:20:41 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45378 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2CEHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:20:40 -0500
Date: Mon, 5 Mar 2012 10:22:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, smatch@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: Smatch v1.56 released
Message-ID: <20120305072220.GL22598@mwanda>
References: <20120304180455.GA1003@mwanda>
 <1330886330.7070.22.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dpynvXbW/eW9Tpc3"
Content-Disposition: inline
In-Reply-To: <1330886330.7070.22.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F546927.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dpynvXbW/eW9Tpc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 04, 2012 at 10:38:50AM -0800, Joe Perches wrote:
> On Sun, 2012-03-04 at 21:04 +0300, Dan Carpenter wrote:
> > Smatch still produces a lot of false positives.  Also as bugs get
> > fixed in the kernel, the false positive to real bug ratio gets
> > worse and worse.  But it does find real bugs as well.
>=20
> Perhaps a database of known false positives and a mechanism
> to use it to see only new instances could be created.

What I do is only look at new bugs.  I've got a script
	smatch_scripts/new_bugs.sh
That takes the output from two smatch runs and prints the bugs which
are new.

Artem has a set of scripts he's working on as well.

regards,
dan carpenter


--dpynvXbW/eW9Tpc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVGmsAAoJEOnZkXI/YHqREEwP/3LKxBhtBVeoWKs9dbeFDA0V
xi+jzYfKNJPHU/Bm1JoKwGuSBKGw7+bQ2S3Tifm4d56TLqvue+Ya0pwYug4KUiC1
3WaIoeVyid5QS3LO7DPjHpqRrR4OKhA72QrMqM/h2f+F6VMY3nDoYluQlsBL487Y
AzQ1xy420WI3aFwOO8X/Z+kfKxMOSQqLwxTeeIvgC63WxcBiPRzKdH/zag8FqZXT
8pPtWHTSUQ15Kd2oqE53lXCYVJxZSx/UhKqzvdgSOs/kunYfnFUCKRezxNfpSjhK
5uDK6qYZnyXnBmalmPsfYMUkbQ8EyXWTV8EuSyXbVTdfKsVCBYAPlZXubHfrP7YN
7I9BZ20aCfQDsR3FcBA5yTVOeaJm5F2hP9if8+dgLwA/qFoDDQVJ/xvEAsO8tToP
zBJOzu0iBwvHXzPeA7gjVB/StsKbel7/aZdG4MtdqWdnHZ8cDfpUPY6XyEExeDuI
hfeL5c9vYjjqYgzcKyh+FXvN7Mvm8M81ZFOno2eJFNWZy78wSbIcgO/Oh2ViCw0B
EK4gadum5KEpDIzkVb0uu+PMf3ymRGAh9Ofu3rxnA/o/QnEmJ3mqRGzhIj3uQ+Ly
x342ctSU2tS6tmilifSizPwT1p6CimYvOh9s0p38PwFwr9RgNofkdpwWEg6cBhcQ
gHhuXQjg5eQPMQ6s+ZcZ
=KOa+
-----END PGP SIGNATURE-----

--dpynvXbW/eW9Tpc3--
