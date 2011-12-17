Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1LQH2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:28:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39091 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1LQH2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:28:20 -0500
Date: Sat, 17 Dec 2011 18:28:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: strange commit in the uprobes tree
Message-Id: <20111217182811.ead5e91706f5198f7d7f5560@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Dec_2011_18_28_11_+1100_=1N_rSdkufp14=WF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Dec_2011_18_28_11_+1100_=1N_rSdkufp14=WF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

I just fetched the uprobes tree and noticed that commit 05f7cebbdbc8
("rcu: Introduce bulk reference count") has no patch, just a commit
message.   In the previous version of your tree, the commit had Paul as
author and now has you (which is what brought it to my attention), but
the lack of patch is more interesting ... I do notice that there is
another patch from Paul ("rcu: Introduce raw SRCU read-side primitives")
and was wondering if that replaces the above patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Dec_2011_18_28_11_+1100_=1N_rSdkufp14=WF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7ESLAAoJEECxmPOUX5FEJJ8P/jGBsSROmbYzelfTMlB0O0A2
YzUvIENF+RxIXkxUnjId0ntP+r+4kPXeMuziYNxKM0CusLuzatsM+4waOC0Di2KX
2ePNwwLZyHvzx9QXcLe+wSTaJw7538J/5IdvwEEwu1z08+BdfY9s/02DsQtij0Sl
QOyA5rqrr8B/e2RitdC2ZrbangJOzbbIw1dWbIiCcT1WszUMGhwecu0AG9H3F8wR
Z/6lhAxmA3yFjYbyEJs4lBVhp3Y+Qqv5xU8gOgkIgUnx8d4WLQTWBkhbt/E5FOcd
karLI32IWp2LvJtkHxMCiM+KAHF0vaLRAEhFijMQo032H9tlGlzm87k0ADuWbOHv
7v0CRlgyHWxM1lYTqyU5S9OfZYwgJI1qT5ocp+lU99h5gXtM4pZ+WIzn0BNKKL1b
w63Y31PtAsyXUi39CBxkkrBq29BkpkM7HJz+Pe6+iwwdigo6uQKH3KJx3/uBPFwM
QpzbYZX8Tl/uI922YeWdwBcXxSATbCu09O0g9g8utpAGnQgA7MiQyv94psNtJhxv
vOW3iPDo4e6NJfCQbAk5IWRbxyipcCojgUmZRY/YTPkssxSBFpF4lf3d0N5WNI+R
AWFw6CA4cl2lhDf6ERcdy1BTZIgJSHhUVYPMJxe5lkHC9U1eTXE+pv7X0NHFuCHp
0Q5yoXUBee956ID2XJ2U
=WiuY
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Dec_2011_18_28_11_+1100_=1N_rSdkufp14=WF--
