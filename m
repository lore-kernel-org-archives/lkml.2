Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1IDNxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 09:53:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40394 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1IDNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 09:53:15 -0400
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
In-Reply-To: Your message of "Sat, 03 Sep 2011 10:27:42 PDT."
             <4E62638E.40308@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <4E582577.2060805@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com> <4E61BB42.4090301@zytor.com> <8179020.mG8hWW8BRr@wuerfel> <14427.1315058668@turing-police.cc.vt.edu> <9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com> <19229.1315070217@turing-police.cc.vt.edu>
            <4E62638E.40308@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315144296_5656P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Sep 2011 09:51:36 -0400
Message-ID: <6467.1315144296@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E63826E.012F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315144296_5656P
Content-Type: text/plain; charset=us-ascii

On Sat, 03 Sep 2011 10:27:42 PDT, "H. Peter Anvin" said:

> About ioctl in particular, the ABI has dependencies into almost every 
> single driver in the Linux kernel.  It is hard-coded in the kernel that 
> there are two paths -- native and compat.  Since pointers are going to 
> be 4 bytes, it means we have to use the compat path.

Ah, that's the part I was missing, thanks.

--==_Exmh_1315144296_5656P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOY4JocC3lWbTT17ARAkO4AJ91F5AV7vPU8V9MHWuZR+vgbkXiVwCgi/KQ
MdkKMuZ3vGDXZieKhttvagY=
=ddbp
-----END PGP SIGNATURE-----

--==_Exmh_1315144296_5656P--

