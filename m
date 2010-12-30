Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0L3V4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 16:56:33 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56255 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0L3V4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 16:56:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: Your message of "Thu, 30 Dec 2010 11:17:32 PST."
             <alpine.DEB.2.00.1012301055340.12995@chino.kir.corp.google.com>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com> <20101230124535.GA3306@sgi.com> <201012301350.28862.arnd@arndb.de>
            <alpine.DEB.2.00.1012301055340.12995@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293746165_4931P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Dec 2010 16:56:05 -0500
Message-ID: <15080.1293746165@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D1CFFF7.00CC,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293746165_4931P
Content-Type: text/plain; charset=us-ascii

On Thu, 30 Dec 2010 11:17:32 PST, David Rientjes said:

> Instead of CONFIG_EXPERT select CONFIG_EMBEDDED, we could add a ninth 
> patch which does CONFIG_EMBEDDED select CONFIG_EXPERT and tag it in some 
> way so we know it's only temporary for the merge window to find new 
> CONFIG_EMBEDDED entries.

What's the plan for those people who are currently on (say) 2.6.35, next
upgrade to 2.6.39 or .40, and thus miss the 9th temporary patch? They'll run
'make oldconfig' - if they get prompted, do we want to add a line to the help
text that says "This used to be called EMBEDDED"?


--==_Exmh_1293746165_4931P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNHP/1cC3lWbTT17ARAr1IAKClAKlktw6RhWYaKrnfzgncvlFFpACfe6Pz
w2MAmh0VPM7c7jqWxPO4fdU=
=/lEf
-----END PGP SIGNATURE-----

--==_Exmh_1293746165_4931P--

