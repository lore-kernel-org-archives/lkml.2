Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0K0SMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 13:12:52 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52126 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0K0SMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 13:12:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <gregkh@suse.de>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andres More <more.andres@gmail.com>,
        Charles Cl?ment <caratorn@gmail.com>, devel@driverdev.osuosl.org,
        Mike McCormack <mikem@ring3k.org>, Radu Voicilas <rvoicilas@gmail.com>
Subject: Re: The longest build error ever, ever, ever seen :) (Re: linux-next: Tree for November 26)
In-Reply-To: Your message of "Sat, 27 Nov 2010 08:45:55 PST."
             <20101127164555.GA23508@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTinY3on+arwh-Rvqnbrx_FU4mKDmpwXR_EfkPJ0f@mail.gmail.com>
            <20101127164555.GA23508@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290881547_5841P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 27 Nov 2010 13:12:27 -0500
Message-ID: <256560.1290881547@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4CF14A0C.0146,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290881547_5841P
Content-Type: text/plain; charset=us-ascii

On Sat, 27 Nov 2010 08:45:55 PST, Greg KH said:
> On Sat, Nov 27, 2010 at 09:56:45AM +0100, Zimny Lech wrote:
> > Ave!
> > 
> > 2010/11/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> > > Hi all,
> > >
> > 
> > OMG, LOL, this one is awesome :) The longest build error ever, ever,
> > ever seen! Fscking awesome, someone gets Guiness World Record :)
> > 
> >   LD      drivers/staging/built-in.o
> > drivers/staging/rtl8192e/built-in.o: In function `rtl8192_setBBreg':
> > (.text+0xae00): multiple definition of `rtl8192_setBBreg'
> > drivers/staging/rtl8192u/built-in.o:(.text+0xa1a0): first defined here
> 
> You built both of these drivers into the kernel, which causes the
> problem.  Try building them as modules, or just one as a module, and
> that will solve the problem.

We probably should create some Kconfig magic to prevent this situation?

	depends (othermodule != 'y') || (myself != 'y')

or am I on the wrong track here?


--==_Exmh_1290881547_5841P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM8UoLcC3lWbTT17ARAhg5AJwKE6hh0BXSvwXG7j/H/rpTmkRz0QCg2pF8
oXnCQ43tiM/MyCnbQdyj+Hc=
=KN+I
-----END PGP SIGNATURE-----

--==_Exmh_1290881547_5841P--

