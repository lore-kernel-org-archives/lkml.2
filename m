Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1ICOGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:06:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33722 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1ICOGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:06:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
In-Reply-To: Your message of "Sat, 03 Sep 2011 10:41:16 +0200."
             <8179020.mG8hWW8BRr@wuerfel>
From: Valdis.Kletnieks@vt.edu
References: <4E582577.2060805@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com> <4E61BB42.4090301@zytor.com>
            <8179020.mG8hWW8BRr@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315058668_2927P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 Sep 2011 10:04:28 -0400
Message-ID: <14427.1315058668@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E6233F3.0054,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315058668_2927P
Content-Type: text/plain; charset=us-ascii

On Sat, 03 Sep 2011 10:41:16 +0200, Arnd Bergmann said:

(Admittedly, I'm tuning in late on this discussion, but...)

> For the ioctl interface however, the __u64/__s64 type in the x32 ABI
> must be defined with __attribute__((packed,aligned(4))) to match what
> the kernel implements because it emulates the x86-32 ABI.

Is this a cast-in-stone issue, or is it still not too late to change that?
And if we change that, can we simplify anything?

--==_Exmh_1315058668_2927P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOYjPscC3lWbTT17ARAgq+AJ4i0WPHug64wIxJkpRJ9v9vDcCFrwCgwd+y
tOjjLJMzW536CLfRgthMnc0=
=kpeu
-----END PGP SIGNATURE-----

--==_Exmh_1315058668_2927P--

