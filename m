Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0INRzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:55:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56319 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0INRzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:55:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with unknown NMI
In-Reply-To: Your message of "Tue, 14 Sep 2010 09:48:13 +0200."
             <20100914094813.2601eb86@basil.nowhere.org>
From: Valdis.Kletnieks@vt.edu
References: <20100910184039.GK4879@redhat.com> <1284344389.3269.82.camel@yhuang-dev.sh.intel.com> <20100913141140.GB27371@redhat.com> <20100913172438.37443bf7@basil.nowhere.org> <20100913154750.GA26290@redhat.com> <20100913185721.59ad9b4d@basil.nowhere.org> <20100913175346.GC26290@redhat.com> <20100913200707.3b31429e@basil.nowhere.org> <20100913182354.GE26290@redhat.com> <20100913203654.26724055@basil.nowhere.org> <20100913193655.GF26290@redhat.com> <20100913224952.442d7a24@basil.nowhere.org> <74508.1284413121@localhost>
            <20100914094813.2601eb86@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284486875_4681P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Sep 2010 13:54:35 -0400
Message-ID: <16821.1284486875@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4C8FB6DB.035F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284486875_4681P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Sep 2010 09:48:13 +0200, Andi Kleen said:

> It's already implemented for MCE and it works on servers.

I'm OK with snarfing up some NVRAM, as long as we have some way to check "yes,
there are NN bytes of NVRAM architected for our use".

Did I miss the memo where it says "This code will only run on chipsets that
have architected nvram space for this sort of use"?  Wouldn't be the first time
I've misunderstood what code is really doing. ;)


--==_Exmh_1284486875_4681P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMj7bbcC3lWbTT17ARAk/wAJoDDs5RCxZccBN6cBe8Rit8xVeiyACeOnIc
Rbr04Q2i7bj0ViEYOdIrM6U=
=v2SF
-----END PGP SIGNATURE-----

--==_Exmh_1284486875_4681P--

