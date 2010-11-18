Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab0KRVqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:46:55 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48336 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab0KRVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:46:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org
Subject: Re: mmotm 2010-11-17-17-03 uploaded
In-Reply-To: Your message of "Thu, 18 Nov 2010 13:29:00 PST."
             <20101118132900.2d7e2a11.randy.dunlap@oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <201011180135.oAI1Znl3017273@imap1.linux-foundation.org> <73121.1290115539@localhost>
            <20101118132900.2d7e2a11.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290116802_6548P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Nov 2010 16:46:42 -0500
Message-ID: <83508.1290116802@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4CE59EC3.0049,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290116802_6548P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Nov 2010 13:29:00 PST, Randy Dunlap said:
> On Thu, 18 Nov 2010 16:25:39 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 17 Nov 2010 17:03:30 PST, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-11-17-17-03 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > Using my current .config and a 'make oldconfig' dies a horrid quick death:
> 
> 
> Hi,
> 
> Yep, this has been fixed in mainline now.

Turns out I don't need CONFIG_BKL anymore for anything I actually use, and setting that =n
worked around it just fine.

--==_Exmh_1290116802_6548P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM5Z7CcC3lWbTT17ARAsyuAJ969obZFk/nnj2dOuS/YKI9pn8P0gCguCHz
t46Sc6hjYaMWpsfUNTAr6kQ=
=t6LT
-----END PGP SIGNATURE-----

--==_Exmh_1290116802_6548P--

