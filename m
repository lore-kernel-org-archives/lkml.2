Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0IMNVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:21:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48126 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab0IMNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:21:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: Look for .get_maintainer.conf in lk, then $HOME then scripts
In-Reply-To: Your message of "Sun, 12 Sep 2010 22:21:39 PDT."
             <1284355299.22185.65.camel@Joe-Laptop>
From: Valdis.Kletnieks@vt.edu
References: <1284111212-10659-1-git-send-email-florian@mickler.org> <1284111767.1783.35.camel@Joe-Laptop> <20100910123040.5a6f0128@schatten.dmk.lab> <30366.1284350506@localhost>
            <1284355299.22185.65.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284384059_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Sep 2010 09:21:00 -0400
Message-ID: <4706.1284384060@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4C8E253C.01B8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284384059_4646P
Content-Type: text/plain; charset=us-ascii

On Sun, 12 Sep 2010 22:21:39 PDT, Joe Perches said:
> On Mon, 2010-09-13 at 00:01 -0400, Valdis.Kletnieks@vt.edu wrote:
> > Any chance of getting that to be ~/.get_maintainer.conf rather than
> > ./.get_maintainer.conf? I've just gotten bit like the 3rd or 4th time by "oh but
> > you didn't create that file in *this* tree" (I usually have a linus git tree, a linux-next
> > tree, and 3-4 -mm trees lying around).
> 
> Sure.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index b228198..ea54561 100755

Thanks dude, you rock. :)

--==_Exmh_1284384059_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMjiU7cC3lWbTT17ARAhhVAJ0XlDNDFV2lMMx/AdxpnDh8eT3zLgCdGafy
ixegDRzNZID53DEAJ0Xb0tY=
=bbeX
-----END PGP SIGNATURE-----

--==_Exmh_1284384059_4646P--

