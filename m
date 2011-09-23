Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1IWXrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:47:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39804 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1IWXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:47:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Parag Amritkar <paragamritkar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Use of inode for storing security info
In-Reply-To: Your message of "Fri, 23 Sep 2011 23:48:36 +0530."
             <CAAjPY7buwGHCtYwrskbHwJV_rK9nD7LiAyZOpgUbHFcWBFudWg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAAjPY7buwGHCtYwrskbHwJV_rK9nD7LiAyZOpgUbHFcWBFudWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316821625_33036P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 19:47:05 -0400
Message-ID: <38386.1316821625@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E7D1A7A.004C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316821625_33036P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Sep 2011 23:48:36 +0530, Parag Amritkar said:
> Can we use any field of inode for storing information like storing
> encryption key of that file?

You probably want to look at how the various security LSMs use
the "security.*" extended attribute namespace to store labels and
similar information.

Protip: You don't want to store the encryption key of the file there.
That's basically leaving the key under the doormat - and a sign saying
"look under doormat for key".

--==_Exmh_1316821625_33036P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfRp5cC3lWbTT17ARAlmaAKD1vb8bZQc+WLc8bdku1/vk6wfIEACfWaxr
2LQ7eQcZ/8HLP7W4hen7meE=
=0nO4
-----END PGP SIGNATURE-----

--==_Exmh_1316821625_33036P--

