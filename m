Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab0KYGJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:09:49 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:49677 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0KYGJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:09:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mike Galbraith <efault@gmx.de>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-11-23 + autogroups -> inconsistent lock state
In-Reply-To: Your message of "Wed, 24 Nov 2010 13:25:25 MST."
             <1290630325.4050.12.camel@maggy.simson.net>
From: Valdis.Kletnieks@vt.edu
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org> <6003.1290574869@localhost>
            <1290630325.4050.12.camel@maggy.simson.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290665343_5841P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Nov 2010 01:09:03 -0500
Message-ID: <5990.1290665343@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4CEDFD80.00EC,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290665343_5841P
Content-Type: text/plain; charset=us-ascii

On Wed, 24 Nov 2010 13:25:25 MST, Mike Galbraith said:
> On Wed, 2010-11-24 at 00:01 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 23 Nov 2010 16:13:06 PST, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > (I appear to be on a roll tonight - 3 splats before I even had a chance to login. :)
> > 
> > mmotm + Ingo's cleanup of Mike's autogroups patch.
> ...
> 
> Sorry for slow response, been trying to use some of my last few vacation
> days on vacation stuff ;-)
> 
> The below should run gripe free.  Suppose I should learn to turn on
> lockdep and whatnot when tinkering/testing.

Yes, this version runs quietly, thanks.


--==_Exmh_1290665343_5841P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7f1/cC3lWbTT17ARAginAKC3C2GmY8SqekMlUrSs07yVyw8RmQCg2IXy
Lgk6PmE9ILGcMbQYlbW2vLE=
=Elzs
-----END PGP SIGNATURE-----

--==_Exmh_1290665343_5841P--

