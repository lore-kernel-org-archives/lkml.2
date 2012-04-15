Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab2DOX6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 19:58:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46048 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2DOX6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 19:58:40 -0400
Date: Mon, 16 Apr 2012 09:58:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <daniel.vetter@ffwll.ch>
Subject: Re: linux-next: triage for April 15, 2012
Message-Id: <20120416095829.b9b1c9fcede7bc0c86a999f4@canb.auug.org.au>
In-Reply-To: <20120415223049.GA17089@windriver.com>
References: <20120415223049.GA17089@windriver.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_09_58_29_+1000_Rbs.PPXtf=0s4UV/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_09_58_29_+1000_Rbs.PPXtf=0s4UV/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Sun, 15 Apr 2012 18:30:49 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> All new breakage is in pagemap.h ; it seems a fix has been
> posted already.
>=20
> 	http://marc.info/?l=3Dlinux-kernel&m=3D133441945530527&w=3D2

And that patch has been added to the drm tree and so will be in today's
linux-next.

> powerpc:allyesconfig
> 	when:	May 18 2009, 22:11
> 	why:	fat ass kernel with everything simply won't link
> 	status:	need to fix build config to ignore the final link
> 	fix:=09
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5806793/

This is well known, so is probably not worth reporting any more.  I am
having a (slow) look at fixing it properly, but that is a long term goal.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Apr_2012_09_58_29_+1000_Rbs.PPXtf=0s4UV/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi2ClAAoJEECxmPOUX5FE8VgP/Rtb35jOVuHTZFzETlIIGUPb
Ov6z5uFGS9I0fIizxCtfPjGf1zeMH/+Yi4StEK0XjOzhZS5xo7i0PAgMh16o1Z0e
tvG8xd8nKJFGivQMRcvuwtTx3ROWf9cxjjgT0n3oPpvh+DEWh9um7Anv+lYVTPUr
PCy8OuKnNlDsJLKTCM1xhgAF1Ixg0Ln3U1CTk8R07ffdVCjRF4V0rAVukFR9qmxw
FhvRoT8/srfbHgBLCQueC7Sx8SyEsF6Wmw5ZcmkgXirNMzOfaYT4sbLM7EV/tAMO
+evPoEk8d5byrrksz6MhjjJ1L9bC7uA6lZb7wsCn5zvyKkw5F2whQUNLqLs5aRJE
pmzHDOsuLkrlLDhUCYGWX3xDn79EIVXj3yxeWg78W0qpO2tlB/YNnpG6zpYZVUPq
IIsZw8ftKGmDYYNzKAETZykk+qxQC6g30M731KAUoI7lTALEvkRo7+KGO1NQN5l2
gvVdZKIWUqid8nEZQK53N8SJ5dC+QqZggJAKM5iTs1j5FsouqB3/TRTmUrVe6KbJ
59npp9aKWyS0JeyeeBO4xhnVciM/S+nTlY274QcsczNsCcakGThktRd/w1SJCv4A
C0cD7gwdhTEAfFl/g6KEKSIrcBPOpHHu6KPHSodeHUkcrw6mLxPOvo7dPZf+jwNB
EuHobOn230X8IXy45Nnp
=Y+EP
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_09_58_29_+1000_Rbs.PPXtf=0s4UV/--
