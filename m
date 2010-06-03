Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0FCQHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:07:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46492 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0FCQHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:07:08 -0400
Date: Fri, 4 Jun 2010 02:06:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot failure with next-20100603
Message-Id: <20100604020659.1be823cf.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.1006030748590.8175@i5.linux-foundation.org>
References: <20100603174251.226da45d.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1006030748590.8175@i5.linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Jun_2010_02_06_59_+1000_JeIPZy87WEE=gZDO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jun_2010_02_06_59_+1000_JeIPZy87WEE=gZDO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 3 Jun 2010 07:51:35 -0700 (PDT) Linus Torvalds <torvalds@linux-foun=
dation.org> wrote:
>
> I can't read PPC oopses in my sleep the way I can do x86, and in=20
> particular, I can't pinpoint that to the source code by just decoding the=
=20
> instructions and matching them against what I have. Do you have that=20
> binary, and can you do a 'gdb vmlinux' on it, and then have gdb tell you=
=20
> where in load_module "load_module+0x990" and "load_module+0x958" are?

I was hoping to avoid that :-)

Rusty seems to have already figured out an obvious cause, so I will see
if that fixes it tomorrow (later today).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Jun_2010_02_06_59_+1000_JeIPZy87WEE=gZDO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwH0yMACgkQjjKRsyhoI8zNlACfTPXLFBhMHGMKKJ0SGrlZoax2
QssAn3rlGkLuKyuAZn7MGm8ecZ3WZBi/
=IakR
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jun_2010_02_06_59_+1000_JeIPZy87WEE=gZDO--
