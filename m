Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1DPTqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 15:46:18 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58367 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1DPTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 15:46:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Francis Moreau <francis.moro@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the last build
In-Reply-To: Your message of "Sat, 16 Apr 2011 17:57:23 +0200."
             <BANLkTin9ggGY9GWOf2_nYmYUsnovmgz82A@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com> <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com> <20110416135912.GA1044@merkur.ravnborg.org> <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com> <61322.1302964434@localhost> <BANLkTimSa7=HiSKET4FSR5zqa1mXf2xGFw@mail.gmail.com> <62853.1302966525@localhost> <BANLkTi=pZPvDbffuW1X2qVVP_xk5FzmrQQ@mail.gmail.com>
            <BANLkTin9ggGY9GWOf2_nYmYUsnovmgz82A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302983165_54890P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Apr 2011 15:46:05 -0400
Message-ID: <81798.1302983165@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4DA9F200.00FE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302983165_54890P
Content-Type: text/plain; charset=us-ascii

On Sat, 16 Apr 2011 17:57:23 +0200, Francis Moreau said:

> The user modify a file, then instead of calling 'make' (because he
> forgets) run the script that send the kernel image through the net on
> a test machine. Since the user had already compiled the kernel before,
>  the kernel image exists but is outdated.

As I said, this is an example of a broken development environment, or
possibly a broken developer. :)

> How can a script detect this case if it doesn't call 'make' in its turn ?

Why do you care about detecting it without calling make?  Just go ahead and
*do* it, if the kernel is up to date it won't take long.  With a completely
cold cache, it takes about 90 seconds on my laptop.  Cache-hot is closer to 45
seconds. If that's too long, buy the developer a real machine or a compile
farm.  If that's a problem, you'll need to put the developer inside a script
that enforces "you *vill* do dis, then you *vill* do dat" fascism so the
programmer never gets a chance to do something you didn't expect.


--==_Exmh_1302983165_54890P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqfH9cC3lWbTT17ARAux9AKDn1WrKMODq8zsQONaoJUe/XOW6agCdHuKZ
762AWwspor/YDEY499casNU=
=1IBr
-----END PGP SIGNATURE-----

--==_Exmh_1302983165_54890P--

