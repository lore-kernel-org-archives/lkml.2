Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0HBPMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:12:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47724 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0HBPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:12:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] vfs: only add " (deleted)" where necessary
In-Reply-To: Your message of "Mon, 02 Aug 2010 15:35:20 +0200."
             <E1OfvAm-0003eo-OP@pomaz-ex.szeredi.hu>
From: Valdis.Kletnieks@vt.edu
References: <20100802111955.025275647@szeredi.hu> <20100802112024.851698363@szeredi.hu> <215565.1280754056@localhost>
            <E1OfvAm-0003eo-OP@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280761913_3871P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Aug 2010 11:11:53 -0400
Message-ID: <8199.1280761913@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4C56E03A.01F2,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280761913_3871P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Aug 2010 15:35:20 +0200, Miklos Szeredi said:

> > I'd prefer the comment about it being ambiguous remain.  I'm waiting
> > to see how long it takes for somebody to create a security hole by
> > creating a file called '/etc/some/thing/important (deleted)' and
> > having some software Do The Wrong Thing instead to
> > /etc/some/thing/important.
> 
> The same comment is left intact on top of d_path().
> 
> It is removed from __d_path() because this function no longer appends
> "(deleted)".

Oh, OK.  Obviously -ENOCAFFEINE on my part, I thought you were nuking the
d_path() copy. ;)


--==_Exmh_1280761913_3871P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMVuA5cC3lWbTT17ARAurcAKDIB47qGyrKmI+5V0Cdb4Jr/EwAIwCgwmoB
aqCg98YNdKyT0aZ1LeStBx0=
=u+6j
-----END PGP SIGNATURE-----

--==_Exmh_1280761913_3871P--

