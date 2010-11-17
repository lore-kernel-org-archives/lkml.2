Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0KQEFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:05:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60422 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0KQEFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:05:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Florian Mickler <florian@mickler.org>, Jesper Juhl <jj@chaosbits.net>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: Your message of "Tue, 16 Nov 2010 14:55:51 GMT."
             <20101116145551.49c47df5@lxorguk.ukuu.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com> <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net> <34565.1289866395@localhost> <20101116110310.1502de2a@lxorguk.ukuu.org.uk> <20101116140341.42561c84@schatten.dmk.lab>
            <20101116145551.49c47df5@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1289966681_4694P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Nov 2010 23:04:41 -0500
Message-ID: <18510.1289966681@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4CE3545A.00E3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1289966681_4694P
Content-Type: text/plain; charset=us-ascii

On Tue, 16 Nov 2010 14:55:51 GMT, Alan Cox said:
> > How does one mark it apropriately?
> > The commit 51b1bd2 (oom: deprecate oom_adj tunable, see below) 
> > added it to feature-removal-schedule.txt, a patch for
> > Documentation/ABI has also been provided in the meantime, if i'm not
> > mistaken. 
> 
> Yes - so why is it spewing crap, annoying users and trying to irritate
> application authors. It's not 2012 yet.

Aug 2012 is only 6 kernel releases or so away....

Presumably the whinging is so we start tracking down the offending userspace
and getting it fixed before 2012 gets here.  Sticking the warning in just one
or two kernel releases before it becomes official leads to "I can't run the new
kernel because my userspace isn't patched yet".  We really can't win here,
we don't whinge and stuff doesn't get tracked down and fixed, we do whinge
and that gets people upset too.

--==_Exmh_1289966681_4694P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM41RZcC3lWbTT17ARAo+YAJ9A0IvKvJ24BXUEw/yGtF8CYDd76ACeNGbA
iqdFFSVCusUYWMcpTlokjY0=
=5h2H
-----END PGP SIGNATURE-----

--==_Exmh_1289966681_4694P--

