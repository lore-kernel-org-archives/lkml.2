Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1DOT3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:29:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43909 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1DOT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:29:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-04-14 - hangs during boot.
In-Reply-To: Your message of "Fri, 15 Apr 2011 21:06:22 +0200."
             <1302894382.2035.35.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org> <9629.1302879429@localhost> <6325.1302893631@localhost>
            <1302894382.2035.35.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302895705_5065P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Apr 2011 15:28:25 -0400
Message-ID: <8571.1302895705@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DA89C5B.004F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302895705_5065P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Apr 2011 21:06:22 +0200, Peter Zijlstra said:

> Does your kernel contain c2f7115e2e52a6c187b8c1f54f0e4970bb677be0 ? If
> not, mmotm is based on an old -next and should upgrade ;-)

Seems to include only so far:

GIT 9e06a6ea7f6cd992bcaa8c469d3831cb9d7d71d9 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

commit 9e06a6ea7f6cd992bcaa8c469d3831cb9d7d71d9
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Apr 14 14:34:58 2011 +1000

    Add linux-next specific files for 20110414

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I'll see if I can cherrypick that c2f711 commit out and apply it, or have you been churning
it that much in the last 24 hours? :)



--==_Exmh_1302895705_5065P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqJxZcC3lWbTT17ARAnN1AJoCnXvpi20Xj9pLmyvBtKUoph3msACeOsLY
A7EFuh6f41w3kITUxNkqJRo=
=B9cu
-----END PGP SIGNATURE-----

--==_Exmh_1302895705_5065P--

