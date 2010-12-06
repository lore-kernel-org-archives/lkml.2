Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab0LFA3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:29:13 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:36208 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0LFA3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:29:12 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Colin Walters <walters@verbum.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
In-Reply-To: Your message of "Sat, 04 Dec 2010 15:01:16 EST."
             <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop> <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net> <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net> <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net> <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com> <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
            <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291595300_67929P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 05 Dec 2010 19:28:20 -0500
Message-ID: <201565.1291595300@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4CFC2E25.0173,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291595300_67929P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <201559.1291595300.1@localhost>

On Sat, 04 Dec 2010 15:01:16 EST, Colin Walters said:

> Look around...where?  On what basis are you making that claim?  I did
> a quick web search for "unix background process", and this tutorial
> (in the first page of Google search results) aimed at grad students
> who use Unix at college definitely describes "nice make":
> http://acs.ucsd.edu/info/jobctrl.shtml

The fact that something is documented doesn't mean the documentation actually
is correct.

There exists a Linux guide written by somebody (who has enough of a rep that
you can safely say "should have known better") who didn't understand the
difference between traditional Unix and Linux, nor what the original concept
was, and it documented the proper way to take a system down quickly as:

# sync;sync;sync;halt

Of course, the *original* was:

# sync
# sync
# sync
# halt

And the whole point of 3 syncs was that the typing time of the second and third
sync's chewed up the time till the first sync finished.  Of course, sync;sync
doesn't  start the first sync and then make you type.  And it overlooked that
the Linux sync is a lot more synchronous than the ATT Unix sync, which returned
as soon as the I/O was scheduled, not completed.


--==_Exmh_1291595300_67929P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFM/C4kcC3lWbTT17ARAuqDAJ4uZu+HwjE4w0MRXVjJWUE4rEH6WACY03CS
08xgStJ7qqW4vu+DC8uf5w==
=5vU+
-----END PGP SIGNATURE-----

--==_Exmh_1291595300_67929P--

