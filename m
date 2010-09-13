Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab0IMECj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:02:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39627 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0IMECi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:02:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Florian Mickler <florian@mickler.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by default
In-Reply-To: Your message of "Fri, 10 Sep 2010 12:30:40 +0200."
             <20100910123040.5a6f0128@schatten.dmk.lab>
From: Valdis.Kletnieks@vt.edu
References: <1284111212-10659-1-git-send-email-florian@mickler.org> <1284111767.1783.35.camel@Joe-Laptop>
            <20100910123040.5a6f0128@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284350506_6472P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Sep 2010 00:01:46 -0400
Message-ID: <30366.1284350506@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4C8DA22B.0174,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284350506_6472P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Sep 2010 12:30:40 +0200, Florian Mickler said:

> Your mileage may vary of course, but I can't see any harm done by this
> change. Anyone familiar with get_maintainer.pl can always just put
> "--nogit" in his .get_maintainer.conf file. 

Any chance of getting that to be ~/.get_maintainer.conf rather than
./.get_maintainer.conf? I've just gotten bit like the 3rd or 4th time by "oh but
you didn't create that file in *this* tree" (I usually have a linus git tree, a linux-next
tree, and 3-4 -mm trees lying around).


--==_Exmh_1284350506_6472P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMjaIqcC3lWbTT17ARAkVfAJ9j7jRoSq54UmozQnUg6apopDimCQCfffAh
ESQVwa9y5JhJsJ2M21KqSZ0=
=MmNN
-----END PGP SIGNATURE-----

--==_Exmh_1284350506_6472P--

