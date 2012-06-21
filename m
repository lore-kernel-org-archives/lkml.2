Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab2FUM2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:28:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:9050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab2FUM2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="160664631"
Message-ID: <1340281963.13910.213.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] udf: stop using s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jun 2012 15:32:43 +0300
In-Reply-To: <20120604134409.GB11010@quack.suse.cz>
References: <1338810384-26437-1-git-send-email-dedekind1@gmail.com>
	 <20120604134409.GB11010@quack.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QW5M6kbjA22D/oQvFzcl"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QW5M6kbjA22D/oQvFzcl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-04 at 15:44 +0200, Jan Kara wrote:
> On Mon 04-06-12 14:46:24, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >=20
> > The UDF file-system does not need the 's_dirt' superblock flag because =
it does
> > not define the 'write_super()' method. This flag was set to 1 in few pl=
aces and
> > set to 0 in '->sync_fs()' and was basically useless. Stop using it beca=
use it
> > is on its way out.
>   Thanks. I've merged the patch to my tree.

Sorry Jan, but which one? I do not see it here at least:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs

[I am trying to find out which bits and pieces of this work are where]

--=20
Best Regards,
Artem Bityutskiy

--=-QW5M6kbjA22D/oQvFzcl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4xRrAAoJECmIfjd9wqK0IQAP/i5YbTHHxRul+fXjq1hpT7jl
n9Dwb6tSzZvDvi9K1/cyhCztPy4GUMItvRbrX+te1ZZqwdfEoGlmH6v/3tRZU3g8
RP++TWDQawj4v5YoJmWTSOFd15D1+J84mz/LeG1ndhzsk/RKu/k05eqzWb1/wY41
nhQ9OCFTY7ZJGKGk0GLjwqQGrh+pcotNOCxo5IegnKITMd1X1Wv9zy563225XHxg
z888WRYMeezUnPVPnk/tyOzpP/6HrZqMnmc2AM7NxCVYSAw7a3Fxrybo5abNhTTT
VsIJGWuLiWXFfZu4Po+TgoJUE//kIm0OO4UC3Z9u0YE9r+3JWPN5GYkho1bQBN+a
92ffh5Ise9KyE5NB/QspUaeGxSEufI0O0A3DTLnaw4oeNVr30PwrG56FsmLs4JZx
y4qfe3FSAm5s5rLL/ihn4bWxMhEUyYwDRw36VIN9bWU7O1GRDFsCcAxiSSlYzitF
0PVSWBVYef1HLOE1AXoIfuPNDMJ42MZCBQ8aaTxzdd2OBspe7DqLWfZtgwNG3Kks
OV6SBjxPbVu/wm82IiiLGLq13GuNRcHGx+3zptvJe4nniTmOd4FNXgr3e3w9PToy
C0Jp8HaigD/0gPCqXMNclhG+7xqIBkgw9CAZ4QU7BbX1aB7Qz69v3zXgoAqXL8r1
mr+pHaKsOGCxteNIZNoo
=Q4hR
-----END PGP SIGNATURE-----

--=-QW5M6kbjA22D/oQvFzcl--

