Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1FASac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:30:32 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50302 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1FASab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:30:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
In-Reply-To: Your message of "Wed, 01 Jun 2011 13:41:56 EDT."
             <BANLkTinKKmXYBLwc_cQBVcs-jgh_1SV6NQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <cover.1306847455.git.luto@mit.edu> <7e604b2dd699a30204fda3d1011f3af5a2c56572.1306847455.git.luto@mit.edu> <10442.1306949732@turing-police.cc.vt.edu>
            <BANLkTinKKmXYBLwc_cQBVcs-jgh_1SV6NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306952865_2661P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Jun 2011 14:27:45 -0400
Message-ID: <13093.1306952865@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DE684A4.0178,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306952865_2661P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Jun 2011 13:41:56 EDT, Andrew Lutomirski said:

>> + =A0 =A0 =A0 =A0 On a system with recent enough glibc (probably 2.14 =
or
>>  + =A0 =A0 =A0 =A0 newer) and no static binaries, you can say N withou=
t a
>>  + =A0 =A0 =A0 =A0 performance penalty to improve security
>>
>> So I checked my laptop (Fedora 16 Rawhide), and found a bunch of stati=
c binaries. The ones
>> that look like people may care:

> The binaries will still work -- they'll just take a small performance
> hit (=7E220ns on Sandy Bridge) every time they call time().

Ah. I misparsed the Kconfig help - I read it as =22If you have no static =
binaries,
setting this to N doesn't introduce a performance hit=22 (with an implied=
 =22if you
have static binaries, this will hose you=22).  Adding =22Static binaries =
will continue
to work at a very small performance penalty=22 would probably help.

--==_Exmh_1306952865_2661P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN5oShcC3lWbTT17ARAukDAKDAnFF5saZAHWCj18NYMaWQIKJENgCg+x2r
GLS1PNJRRid/M4Mg16YHa78=
=zbmb
-----END PGP SIGNATURE-----

--==_Exmh_1306952865_2661P--

