Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1JYJTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:19:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38541 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1JYJTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:19:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Markus Kolb <linux-201011@tower-net.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question to directory setgid bit FS implementation details
In-Reply-To: Your message of "Tue, 25 Oct 2011 10:55:55 +0200."
             <af8d5834d1bfb5f19aaf7deba6caa1a0@mail.net4visions.de>
From: Valdis.Kletnieks@vt.edu
References: <af8d5834d1bfb5f19aaf7deba6caa1a0@mail.net4visions.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319534364_3131P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 05:19:24 -0400
Message-ID: <15714.1319534364@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4EA67F20.000E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319534364_3131P
Content-Type: text/plain; charset=us-ascii

On Tue, 25 Oct 2011 10:55:55 +0200, Markus Kolb said:

> can you please explain in brief how the creation of files
> in directories with setgid bit set is implemented in
> filesystems.

Look in fs/inode.c, function inode_init_owner(). All of 8 lines of code.

--==_Exmh_1319534364_3131P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpn8ccC3lWbTT17ARAnUnAKCOJp4N+eFeCWPj6iK2DCJz7mBmoACePC/D
jT++MCC6lDQ0lNOr9VncVXQ=
=2rMA
-----END PGP SIGNATURE-----

--==_Exmh_1319534364_3131P--

