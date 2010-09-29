Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0I2BUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:20:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59840 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0I2BT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:19:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
In-Reply-To: Your message of "Wed, 29 Sep 2010 02:57:59 +0200."
             <AANLkTin+JRpTZsFO-neZ1Di=tskGK2Ne=xEKKpZrRB1C@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org> <AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com> <124506.1285721384@localhost>
            <AANLkTin+JRpTZsFO-neZ1Di=tskGK2Ne=xEKKpZrRB1C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1285723160_8264P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Sep 2010 21:19:20 -0400
Message-ID: <137549.1285723160@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4CA29419.0199,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1285723160_8264P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Sep 2010 02:57:59 +0200, "N.P.S. N.P.S." said:
> 2010/9/29  <Valdis.Kletnieks@vt.edu>:
> > On Wed, 29 Sep 2010 02:27:55 +0200, "N.P.S. N.P.S." said:
> >> Hi,
> >>
> >> 2010/9/29 =A0<akpm@linux-foundation.org>:
> >> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> >>
> >> I wonder why are these two functions in include/linux/fs.h
> >> static inline void lock_flocks()
> >> {
> >> }
> >>
> >> static inline void unlock_flocks()
> >> {
> >> }
> >
> > Those were added as part of the kill-the-BKL project. =A0They used to be
> > done as #defines to lock_kernel and unlock_kernel, but became full-fledge=
> d
> > functions in this release. =A0Unfortunately, if you build with CONFIG_FIL=
> E_LOCKING=3Dn
> > you need to provide a dummy stub, which is what was intended here.
> >
> > Does the following (untested) fix the problem for you?
> 
> Yes, it does. Thanks!

And right after that I spotted that Randy Dunlap posted an almost identical
patch (with better changelog) earlier this afternoon...

--==_Exmh_1285723160_8264P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMopQYcC3lWbTT17ARApDtAKCLSUysQifMGbIYx45ysv6eBwHfhwCg+B/A
T5Ptdurx+8J3bxcEL7pKkHE=
=YvQw
-----END PGP SIGNATURE-----

--==_Exmh_1285723160_8264P--

