Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0FLIu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 04:50:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51941 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0FLIuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 04:50:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded - busticated patch?
In-Reply-To: Your message of "Fri, 11 Jun 2010 16:40:13 PDT."
             <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276332636_49244P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Jun 2010 04:50:36 -0400
Message-ID: <52510.1276332636@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C134A5D.0185,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1276332636_49244P
Content-Type: text/plain; charset=us-ascii

On Fri, 11 Jun 2010 16:40:13 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch contains this
hunk:

diff -puN mm/rmap.c.orig~mm-extend-ksm-refcounts-to-the-anon_vma-root-fix mm/rmap.c.orig
--- a/mm/rmap.c.orig~mm-extend-ksm-refcounts-to-the-anon_vma-root-fix
+++ a/mm/rmap.c.orig

which blows chunks because there's no rmap.c.orig in the tree.  Not sure what
that section was supposed to do, or what it was supposed to apply to.

--==_Exmh_1276332636_49244P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFME0pccC3lWbTT17ARAu/FAKCPMmlN2onQvlQbyJ1Ho1PtYRYtwgCbBh8j
FlJV/yP6dH5lPZf0i0+aESE=
=qiok
-----END PGP SIGNATURE-----

--==_Exmh_1276332636_49244P--

