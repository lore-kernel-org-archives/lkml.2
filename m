Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0KRAMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:12:33 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:49347 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0KRAMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:12:31 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [Security] proactive defense: using read-only memory
In-Reply-To: Your message of "Wed, 17 Nov 2010 11:00:54 +0100."
             <20101117100053.GA1574@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <20101107193520.GO5327@outflux.net>
            <20101117100053.GA1574@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290039147_4778P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Nov 2010 19:12:27 -0500
Message-ID: <32620.1290039147@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4CE46F6B.0121,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290039147_4778P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Nov 2010 11:00:54 +0100, Pavel Machek said:

> > - Entry points to set_kernel_text_rw() and similar need to be blockable.
> >   Having these symbols available make kernel memory modification trivial;
> 
> What prevents attacker to just inlining those functions in the
> exploit?

Quite often, you are limited on how many bytes of exploit code you can inject.
If you have to do the whole thing in (say) 139 bytes, having to inlinine even
one function may make the exploit impossible to run.


--==_Exmh_1290039147_4778P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM5G9rcC3lWbTT17ARAtHkAJ0VXmlHfc4wGXWMBIi7BbLRIq+14QCeK5jm
dz7JSQ3MA8rguFjCw9qPIMc=
=BlAi
-----END PGP SIGNATURE-----

--==_Exmh_1290039147_4778P--

