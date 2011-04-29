Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab1D2OKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:10:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50498 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab1D2OKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:10:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jack Steiner <steiner@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK is not set
In-Reply-To: Your message of "Wed, 27 Apr 2011 08:33:18 +0200."
             <20110427063318.GC17079@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20110425181136.055235992@gulag1.americas.sgi.com> <20110425181136.211858618@gulag1.americas.sgi.com> <20110425154835.7d41d89e.akpm@linux-foundation.org> <4DB6FBC2.7000806@sgi.com>
            <20110427063318.GC17079@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304086127_56837P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Apr 2011 10:08:47 -0400
Message-ID: <140960.1304086127@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DBAC675.0081,ss=1,fgs=0,
	ip=71.62.120.129,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304086127_56837P
Content-Type: text/plain; charset=us-ascii

On Wed, 27 Apr 2011 08:33:18 +0200, Ingo Molnar said:
> Also, sendmail does not screw up From: headers that are in the body of the 
> email - forwarding emails is one of the oldest things that can be done to 
> emails.

What some Sendmail configurations *do* eat is lines that start with 'From ' (no
colon). Those will get escaped as '>From ...'  to prevent them from looking
like a separator line for what's known as 'mbox' format - which is basically
the same info as in the Return-Path: header plus a timestamp. They look like:

>From hostmaster@prairie.net Fri Apr 19 15:50:15 2002

(If the above line has a >From, you have the issue.  Yes, it could be smarter
and do a full parse for a mbox header rather than just '^From '.  And yes, I
had to go digging to find an old archived mbox format file to snarf the example
from.


--==_Exmh_1304086127_56837P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNusZvcC3lWbTT17ARAoWcAJ92GxIaAfwEwZB2XTEP1rVuXqHCrwCghdnN
aOPMrYoxtXYAew1ufM4Fi6k=
=+Res
-----END PGP SIGNATURE-----

--==_Exmh_1304086127_56837P--

