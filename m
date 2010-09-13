Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0IMVZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:25:48 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49183 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0IMVZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:25:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with unknown NMI
In-Reply-To: Your message of "Mon, 13 Sep 2010 22:49:52 +0200."
             <20100913224952.442d7a24@basil.nowhere.org>
From: Valdis.Kletnieks@vt.edu
References: <20100910184039.GK4879@redhat.com> <1284344389.3269.82.camel@yhuang-dev.sh.intel.com> <20100913141140.GB27371@redhat.com> <20100913172438.37443bf7@basil.nowhere.org> <20100913154750.GA26290@redhat.com> <20100913185721.59ad9b4d@basil.nowhere.org> <20100913175346.GC26290@redhat.com> <20100913200707.3b31429e@basil.nowhere.org> <20100913182354.GE26290@redhat.com> <20100913203654.26724055@basil.nowhere.org> <20100913193655.GF26290@redhat.com>
            <20100913224952.442d7a24@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284413121_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Sep 2010 17:25:21 -0400
Message-ID: <74508.1284413121@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4C8E96C1.015C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284413121_4646P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Sep 2010 22:49:52 +0200, Andi Kleen said:

> > > That's already supported in MCE -- saving the error record to NVRAM
> > > and logging it after reboot. NMI should probably do the same.
> > > It's much nicer than getting it from a console.
> > 
> > Hmm, that assumes these boxes have NVRAM.  I am not sure if many of
> > the boxes I see with problems have NVRAM on them.
> 
> Practically every PC has a small amount of NVRAM.

The big question is how much NVRAM the PC has that is safe for our NMI code to
hijack/borrow across the reboot without scrogging something that the BIOS has
squirreled away in there. I recall one patch that saved progress indicators during
early boot or something - but at the expense of stomping on the saved clock
settings or whatever so you rebooted and then you knew where your previos boot
wedged, but your system thought it was 1970 again. 


--==_Exmh_1284413121_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMjpbBcC3lWbTT17ARAtK/AJ9eclHOseAwY52J1JV2pe3FUe3H1ACgo3+M
nBdi7RlUl+vQbWA4I5gvDdc=
=/W9O
-----END PGP SIGNATURE-----

--==_Exmh_1284413121_4646P--

