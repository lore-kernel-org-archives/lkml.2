Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1DITYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:24:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46366 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab1DITYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:24:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Joshua Kinard <kumba@gentoo.org>,
        Linux MIPS List <linux-mips@linux-mips.org>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 2/2]: MIPS: sgi-ip32: Add support for rtc-ds1685 to SGI O2 (IP32)
In-Reply-To: Your message of "Fri, 08 Apr 2011 15:25:34 +0200."
             <20110408132533.GA15416@linux-mips.org>
From: Valdis.Kletnieks@vt.edu
References: <4D9DB95F.8040100@gentoo.org>
            <20110408132533.GA15416@linux-mips.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302377025_4802P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 09 Apr 2011 15:23:45 -0400
Message-ID: <105137.1302377025@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DA0B248.00C8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302377025_4802P
Content-Type: text/plain; charset=us-ascii

On Fri, 08 Apr 2011 15:25:34 +0200, Ralf Baechle said:
> On Thu, Apr 07, 2011 at 09:17:19AM -0400, Joshua Kinard wrote:

> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> 
> Please don't PGP sign patches.  Nobody care about your PGP signature as
> long there's a valid Signed-off-by.

Alternatively, fix your mailer to not send a single text/plain that PGP has signed,
but use the MIME multipart/signed construct, where (a) the text/plain main part
isn't changed at all, and (b) the PGP signature is in a separate bodypart.

> > Signed-off-by: Joshua Kinard <kumba@gentoo.org>
> > - ---

> And this is a --- tearoff line corrupted by PGP.  Just like every other line
> starting with a -.

Doing this will prevent that.  The following line should appear as a single dash:

-

See? You *can* have your cake and eat it too. ;)

--==_Exmh_1302377025_4802P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNoLJBcC3lWbTT17ARAhlvAKChAYth386x50ejraQj7tmelO6TQgCgirdh
7nzwhfrPig62Jkqm5eNYxDI=
=Cy9B
-----END PGP SIGNATURE-----

--==_Exmh_1302377025_4802P--

