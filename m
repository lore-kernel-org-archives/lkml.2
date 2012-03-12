Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2CLCLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:11:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43210 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2CLCLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:11:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mark Manning <mark4th@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: bug in the way Linux loads elf files...
In-Reply-To: Your message of "Sun, 11 Mar 2012 17:49:40 CDT."
             <CAPGNrUWYc6xzaqPnLmD12Vaz3mr9hEA6k4OP70FCjhBYM7mVhA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAPGNrUWYc6xzaqPnLmD12Vaz3mr9hEA6k4OP70FCjhBYM7mVhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1331518262_3085P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Mar 2012 22:11:02 -0400
Message-ID: <65215.1331518262@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4F5D5B38.0057,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1331518262_3085P
Content-Type: text/plain; charset=us-ascii

On Sun, 11 Mar 2012 17:49:40 CDT, Mark Manning said:

> i patched MemSiz to be larger than FileSiz which should work but does not.

OK, I'll bite...

1) Does the standard say specfically that MemSiz>FileSize is supposed to work?

2) If it *were* to work, what would it *mean*?  Under what real-world conditions will
we encounter this case?

--==_Exmh_1331518262_3085P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT11bNQdmEQWDXROgAQIjEw//dY5xliHYFvOMaLdwL3pq6Q7QiL/11PUB
CkGf3gVI8nxc1QYR4oXoGn95UM/YLKAsbJlkJN0ffQJ2LWgNF01gnQbqc462vTvO
2uLy6hDdxSAkmHJtIoDO8N8o7zeuNLQ8E/wYqMXppqd1h5VFcOJcEe5LJm2PA3Rr
8XX31++Er/Ek6VZKTVL/7BEwFFgYaQM0MfBWk6Ni/BtoSFMt2zkGeUhR+SpqwgNu
0Y5/khAhT7I+D3EDsCBrgONHGENGkJScO7hHz80cAexTjdNksTPKcMo4MmI9N1Ik
/Qlqd562PJBOP4JoKNrLhQmBb6WNbBQa74pZEHE6uxyQFmMfV7mMVj0APSQGMqCE
uEv4Uuign7x1Q6gS2EpPyeK38Y54fB2FyZohq4srz83JRnvTATjE5I9pP9eiGXgx
7KdXFyCZoPyFuCi/wxglR8M/zNZBt2c/lAgdzFVEoFNI2W4GSzPM9OJwCDsYyx2/
/gZyVD8BdGXTvBDqtN7dI7NHzw0T73Nxhus8UmyMBcMNq6wV9RIfyUHfeclrXPvI
yWUT9qDR8/wMra797SiaVaTLiEd8Ron9VkGZ/BSt/3dGLpDjM6QU7/38zxqJdFUh
H1ZMk9CkWcsqdkn0L7tKxYj5s5f+tpZHd90Japd/9LqPfwBUXr5S7Ht9BGHGfbaI
Z5DPBbTA1Ko=
=VBT9
-----END PGP SIGNATURE-----

--==_Exmh_1331518262_3085P--

