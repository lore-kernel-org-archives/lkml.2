Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1DLCsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:48:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45778 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab1DLCsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:48:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] uts: Set default hostname to "localhost", rather than "(none)"
In-Reply-To: Your message of "Sun, 10 Apr 2011 22:01:59 PDT."
             <20110411050155.GA2507@feather>
From: Valdis.Kletnieks@vt.edu
References: <20110411050155.GA2507@feather>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302576446_5348P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Apr 2011 22:47:26 -0400
Message-ID: <16567.1302576446@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DA3BD40.00F2,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302576446_5348P
Content-Type: text/plain; charset=us-ascii

On Sun, 10 Apr 2011 22:01:59 PDT, Josh Triplett said:

> Change the default hostname to "localhost".  This removes the need for
> the standard fallback, provides a useful default for systems that never
> call sethostname, and makes minimal systems that much more useful with
> less configuration.

Seems sane enough to me.  Only possible objection I can think of is "if you're running
with 'init=/bin/sh' or similar config too crippled to run /bin/hostname, maybe your
network config *should* be intentionally toasted so you can't get further surprises".

I personally don't agree - just saying somebody might hold that position.

--==_Exmh_1302576446_5348P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNo70+cC3lWbTT17ARAtxLAJ9BnedAEgl1e2aWREXcwIqbIbH5eQCg2UKG
JpoAnnWNxvi4EjWolQAk1hw=
=Mx1t
-----END PGP SIGNATURE-----

--==_Exmh_1302576446_5348P--

