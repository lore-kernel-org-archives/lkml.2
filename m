Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0HBNBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:01:11 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46859 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0HBNBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:01:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] vfs: only add " (deleted)" where necessary
In-Reply-To: Your message of "Mon, 02 Aug 2010 13:20:01 +0200."
             <20100802112024.851698363@szeredi.hu>
From: Valdis.Kletnieks@vt.edu
References: <20100802111955.025275647@szeredi.hu>
            <20100802112024.851698363@szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280754056_76572P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Aug 2010 09:00:56 -0400
Message-ID: <215565.1280754056@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4C56C189.0139,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280754056_76572P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Aug 2010 13:20:01 +0200, Miklos Szeredi said:

> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c	2010-07-06 18:08:16.000000000 +0200
> +++ linux-2.6/fs/dcache.c	2010-07-06 18:08:19.000000000 +0200
> @@ -1977,8 +1977,7 @@ global_root:
>   * @buffer: buffer to return value in
>   * @buflen: buffer length
>   *
> - * Convert a dentry into an ASCII path name. If the entry has been deleted
> - * the string " (deleted)" is appended. Note that this is ambiguous.
> + * Convert a dentry into an ASCII path name.
>   *
>   * Returns a pointer into the buffer or an error code if the
>   * path was too long.

I'd prefer the comment about it being ambiguous remain.  I'm waiting to see how
long it takes for somebody to create a security hole by creating a file called
'/etc/some/thing/important (deleted)' and having some software Do The Wrong
Thing instead to /etc/some/thing/important.


--==_Exmh_1280754056_76572P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMVsGIcC3lWbTT17ARAhsYAJ0S6HqXhAC4jZvP3AW9G1dyrt2zZwCg6Ilz
Ex+d+Ab1kZ3eH1j6TLZF94g=
=96rk
-----END PGP SIGNATURE-----

--==_Exmh_1280754056_76572P--

