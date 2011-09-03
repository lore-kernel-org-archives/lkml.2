Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1ICRS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 13:18:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57927 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1ICRS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 13:18:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
In-Reply-To: Your message of "Sat, 03 Sep 2011 09:40:55 PDT."
             <9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com>
From: Valdis.Kletnieks@vt.edu
References: <4E582577.2060805@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com> <4E61BB42.4090301@zytor.com> <8179020.mG8hWW8BRr@wuerfel> <14427.1315058668@turing-police.cc.vt.edu>
            <9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315070217_2927P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 Sep 2011 13:16:57 -0400
Message-ID: <19229.1315070217@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E62610E.011A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315070217_2927P
Content-Type: text/plain; charset=us-ascii

On Sat, 03 Sep 2011 09:40:55 PDT, "H. Peter Anvin" said:
> Valdis.Kletnieks@vt.edu wrote:
> 
> >On Sat, 03 Sep 2011 10:41:16 +0200, Arnd Bergmann said:
> >
> >(Admittedly, I'm tuning in late on this discussion, but...)
> >
> >> For the ioctl interface however, the __u64/__s64 type in the x32 ABI
> >> must be defined with __attribute__((packed,aligned(4))) to match what
> >> the kernel implements because it emulates the x86-32 ABI.
> >
> >Is this a cast-in-stone issue, or is it still not too late to change that?
> >And if we change that, can we simplify anything?
> 
> The complexity of changing that would be enormous.

Oh, I know changing the x86-32 ABI is impossible - I meant changing the
decision to emulate that ABI (as opposed to emulating the x86-64 ABI, or a
variant thereof, or something else).  Or are we already commited to that
route, even if we're still trying to figure out what syscalls to include?




--==_Exmh_1315070217_2927P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOYmEJcC3lWbTT17ARAizvAKDiw3bujQfGuLZ+02eNhK61DxNIcACgvm0K
MVki6r1jB+tSgGrboBA73o4=
=Ihbd
-----END PGP SIGNATURE-----

--==_Exmh_1315070217_2927P--

