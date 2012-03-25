Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2CYCFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 22:05:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42193 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2CYCFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 22:05:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for linux kernel 3.3.0
In-Reply-To: Your message of "Sat, 24 Mar 2012 05:53:32 -0400."
             <201203240553.32526.gene.heskett@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
            <201203240553.32526.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332641134_1934P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Mar 2012 22:05:34 -0400
Message-ID: <57375.1332641134@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4F6E7D6F.008F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332641134_1934P
Content-Type: text/plain; charset=us-ascii

On Sat, 24 Mar 2012 05:53:32 -0400, Gene Heskett said:

> I for one am happy to see this, Con.  I have been running an earlier patch
> as pclos applies it to 2.6.38.8, and I must say the desktop interactivity
> is very much improved over the non-bfs version.

I'va always wondered what people are using to measure interactivity. Do we have
some hard numbers from scheduler traces, or is it a "feels faster"?  And if
it's a subjective thing, how are people avoiding confirmation bias (where you
decide it feels faster because it's the new kernel and *should* feel faster)?
Anybody doing blinded boots, where a random kernel old/new is booted and the
user grades the performance without knowing which one was actually running?

And yes, this can be a real issue - anybody who's been a aysadmin for
a while will have at least one story of scheduling an upgrade, scratching it
at the last minute, and then having users complain about how the upgrade
ruined performance and introduced bugs...


--==_Exmh_1332641134_1934P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT259bQdmEQWDXROgAQKRlQ/+Ok9BAbuzNwNIBElQZjhq8vIjzekapj+V
jO8E7BVFr1SUhEzGHuAEJ/a2xA59Ow/wVvq+czSf09493d8bIQ0ofFStSol64ZaN
/ybmz9zU8YE5PgkTxLMm5E8jp8mgx4GYRhPrv8OQMvwPA8uFvSngIkXXrXggsrYe
ZqL5inzLrC93GvVUQO5hbzdPenGgZE78Ftl46nPfHVj1ZWgno5yL3kMfPnMb9zSO
E/tLTK/6rOlVbC65gzuzq8nlLzPJYd2n5p0WblrLZ6iFa18xP/iklqZOnP//evfV
yExYmAKOKAmHO/0rjp7lBCE5H3W3X/hAne1CWKBUYlR9ZFUMXXlsArwMal+q2OM9
LI3kV9YAU9n/a96iLKsyRJdJh8G2kGE0VL2tJ7cooanirJrozgs0lQpsKp3pWtw/
hSdYx1OHLzVcHxZBY9UC9OZlJLmthFBlfFL2quUelmS9Wtc3N4RkxyCUjsyk2Goh
HJqenhoC1QdN9zpxgte/+GDHdxgCP96v87tR2HoXA6PFHGBSJVrLlrAYVMdXjCIM
kVH5JAEPxHIBhBSoFeK83zMPeOEMLTCkK7pNnC2uV8ssIIlC3n63zf7b50GtI9Hm
ahNVBALBAXr3x4dIfQB7o78Nf59U9cPZcNhYpUWJEesuSTZ/muB4vyyawQYMUt+y
1erqzy4gJLo=
=u/ue
-----END PGP SIGNATURE-----

--==_Exmh_1332641134_1934P--

