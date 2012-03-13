Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2CMOCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:02:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36779 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2CMOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:02:17 -0400
Date: Tue, 13 Mar 2012 17:04:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RCU stalls in linux-next
Message-ID: <20120313140416.GG3395@mwanda>
References: <20120313134822.GA5158@elgon.mountain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEfPc/DjvCj+JzNg"
Content-Disposition: inline
In-Reply-To: <20120313134822.GA5158@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F5F5344.0025,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEfPc/DjvCj+JzNg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 13, 2012 at 04:48:23PM +0300, Dan Carpenter wrote:
> I've been getting RCU hangs in linux-next.
>=20
> Also sometimes, when I'm building my smatch database after a kernel
> compile, my system hangs.  I'm not certain if the two things are related.

It actually seems to be hanging just after I've built my kernel and
do a:  find -name \*.c.smatch -exec cat \{\} \; > warns.txt

My screen froze but I was able to log in via ssh once and type dmesg
but then I hit tab tab twice to trigger the tab completion and it
hung for good.

I'm still not sure the big hang is related to the RCU stalls...

regards,
dan carpenter

--PEfPc/DjvCj+JzNg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX1PfAAoJEOnZkXI/YHqRQysP/32kFNdIv6iKZ5nlVkhSQYil
i8xoD/m3BDRxgLKQDHDcIeRzD9YGiCImjc0C/AElIckd0+EWtbzas2VY9WRkv3EG
4WqZo+W+GllGVT5cZV6gdGbtc1P8NCbn0AMiTLg3DiGvPtHgUtwOvoGGC5BOev8C
lI68JmWO/oKoASKfJjfwUS15FdS5S8XvldVvMFr69AhLnoNP8IIMS4B0k3c0aksQ
Hh2aei4CtCs3S/1fcUBSZY4XC1r7fUNZkAXKK5HROSk2SBSLWoIQ5I1Vknty3gw+
uc+yOIsf1sXQLJqET/oHm0bSWTsZ1bdqHS6UMxna6NGhW0Bhzk7cDx0qOp0/NokW
Kta13j0sMVYmqsY+KDr96j4Dazei0uIctvnFjgDu/U0/ksgeCLpgP/6B8ml47y5S
v2ha7eaJw5LiNZnUi66MsPogYH1b2RfMYOLILSVrpmgdHl//u8BgsLwhMLOI2t/P
qIKcF2RHV0OuPv3c7J/glfoNUT5eUd8KhHXo1t3srJ7Frm7OzslyHSSMM3yyU5b/
5HLw8Hdum9Ri2UfE/YAWoXt+AyLQPQXBd+zd25B2j76uX39EKGymN5uw6uauUR31
t98/q9SQ1IHdpu36X4YivS8QvHw49fKmeoaoeZ5Tc2ER9rhwr1guxR1M88SvjVcn
gWpNjhw0NxvRklGv0mSY
=BP5d
-----END PGP SIGNATURE-----

--PEfPc/DjvCj+JzNg--
