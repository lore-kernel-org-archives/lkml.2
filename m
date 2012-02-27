Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2B0F3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:29:16 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52401 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2B0F3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:29:14 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrei Warkentin <andrey.warkentin@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCHv3 2/3] NETKGDB: Ethernet/UDP/IP KDB transport.
In-Reply-To: Your message of "Sun, 26 Feb 2012 22:30:10 EST."
             <1330313411-845-3-git-send-email-andrey.warkentin@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com> <1330313411-845-1-git-send-email-andrey.warkentin@gmail.com>
            <1330313411-845-3-git-send-email-andrey.warkentin@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1330320543_6549P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Feb 2012 00:29:03 -0500
Message-ID: <116798.1330320543@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4F4B14A2.002A,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1330320543_6549P
Content-Type: text/plain; charset=us-ascii

On Sun, 26 Feb 2012 22:30:10 EST, Andrei Warkentin said:

> +Note: the parameter is optional and largely unneeded unless you
> +are running a listen server - netkgdb will accept connection from any
> +IP on all interfaces and will reconfigure itself appropriately if

This *really* needs a discussion of the security implications of this.  Do
you *really* want to have a kgdb that will accept connections from *anywhere*?
Sounds like an insta-root waiting to happen.

> +the assigned interface IP address changes. This makes it useful
> +in an environment where it's not known ahead of time what computer
> +will connect to perform the crash analysis.

Exactly. You don't know ahead of time who's going to connect. That's the
problem...

--==_Exmh_1330320543_6549P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT0sUnwdmEQWDXROgAQKSkw//Xbl4nTmDtTxYA9sgOvDw8O35P1ytSN/p
uNkUVQ2ry8ash091BM/bfkEVd8qa8cgW+cAliw3lOd7Uke2Vsp5xQNFMHD6Divtx
hOhBOHO6lVQyAKtuf9HFxX2HtMzEQeuv2e4jzOp0kMcWLfg6R12FzPeQElFZph7V
/Tg2n4ICYSR4TGewNOCVkYUNHzwLoWbVw4AMcE6hFvp1RlahOqMuLrDyvgU2Rmj5
vVOrID50jDRYlrB7qNwMBLRYEMgIrojeWqXZ3u34NiM7BGQCIdZwrzvbTpChAN4S
DXlPjOy8dhT1CF1xuSWctNl5pnAn69F4NkSKoIoskrs3X8c+M5LRSYhp87q7oiVE
82qq4WcUu5TbNhepjGvvJrq4fJ91UDy5uV71BarJnGM0QZLgLK23l8+XMUsvQ2Wl
Xe2F9Y01mk0+x3/yis0KlFgnMePiYEKzUFey2B1pWCLp1yZzMvDe3NtHIXlXqbiu
Jta9AyiO4m9sDP1InLspmte0mjH1LuwmhsN6HRroB7Umv2De7H1Fr8/dwSzjLwF0
YaioG4vuoPMAIV6y2WpJYSkbH+Dt2HN7dNoFcavTCqFJEkFIFZURRQcMCCxPbn3j
T5QsZb0gOVol9fAFZy1UznBlBj2Sg7g/3ppgagQbb1Kj0wdM3OBkVN9L5Ench2Nj
VfuLu2iTzfs=
=7WKG
-----END PGP SIGNATURE-----

--==_Exmh_1330320543_6549P--

