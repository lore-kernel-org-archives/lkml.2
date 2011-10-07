Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab1JGQHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:07:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43394 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1JGQHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:07:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?UTF-8?B?UGx1bWJlcuKAmXM=?= Wish List for Linux
In-Reply-To: Your message of "Fri, 07 Oct 2011 11:38:20 BST."
             <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk> <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
            <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318003632_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 12:07:12 -0400
Message-ID: <14289.1318003632@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E8F23B4.0119,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318003632_9306P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Oct 2011 11:38:20 BST, Alan Cox said:

> > What do you mean would be ugly?
> 
> I have an ext4fs. It supports every possible file name allowed by POSIX
> and SuS. What name are you going to use for your 'hidden directory' that
> won't clash with a real file ?

ext4 could always use an attribute bit for that.  Not that *that* solution is all that
much prettier, since you can't use it for filesystems that don't have attribute bits.

--==_Exmh_1318003632_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjyOvcC3lWbTT17ARApWTAJwPRYSaNVyxU6Oddc5kYMT8D5fuiACgyvc2
1rYipa2pwaTFrXEoCElpYew=
=jgOO
-----END PGP SIGNATURE-----

--==_Exmh_1318003632_9306P--

