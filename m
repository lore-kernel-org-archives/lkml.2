Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0GXOnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 10:43:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44567 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0GXOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 10:43:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 0/8] zcache: page cache compression support
In-Reply-To: Your message of "Fri, 23 Jul 2010 14:02:16 EDT."
             <1507379750.1116011279908136772.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1507379750.1116011279908136772.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1279982510_3953P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Jul 2010 10:41:50 -0400
Message-ID: <93365.1279982510@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4C4AFBB0.011B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1279982510_3953P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Jul 2010 14:02:16 EDT, CAI Qian said:
> Ignore me. The test case should not be using mlockall()!

I'm confused. I don't see any mlockall() call in the usemem.c you posted? Or
was what you posted not what you actually ran?


--==_Exmh_1279982510_3953P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMSvuucC3lWbTT17ARAseaAJ4gxpD4bi6+Z3dxvD3HUlTZsmEf2wCeLeQ3
CUr9ficK5W80YcjwJPStvlQ=
=4r0W
-----END PGP SIGNATURE-----

--==_Exmh_1279982510_3953P--

