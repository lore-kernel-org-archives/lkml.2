Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935719Ab0EVCAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 22:00:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54750 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935688Ab0EVCAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 22:00:12 -0400
Date: Sat, 22 May 2010 12:00:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org
Subject: Re: [git pull] drm for 2.6.35-rc1 (revised)
Message-Id: <20100522120003.ee53af22.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.1005211154120.3689@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1005190310010.1205@skynet.skynet.ie>
	<alpine.DEB.2.00.1005210718460.16929@skynet.skynet.ie>
	<alpine.LFD.2.00.1005211154120.3689@i5.linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__22_May_2010_12_00_03_+1000_t7wWGKA7eBKEqBSB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__22_May_2010_12_00_03_+1000_t7wWGKA7eBKEqBSB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Fri, 21 May 2010 11:56:39 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> I suspect we should have some "new warnings are errors" thing for=20
> linux-next, so that people can't do this.

I do attempt to report new warnings but they are often hard to spot among
all the "may be used uninitialised" rubbish of an X86_64 allmodconfig
build.  Also, sometimes people ignore me, of course. :-(

That being said, I did not get the mentioned warning for either an i386
or x86_64 allmodconfig build - I wonder why not?  Compiler differences?
Config differences? (See
http://kisskb.ellerman.id.au/kisskb/buildresult/2617918/ and
http://kisskb.ellerman.id.au/kisskb/buildresult/2617928/).

Ah, I did get it for an i386 defconfig build
(http://kisskb.ellerman.id.au/kisskb/buildresult/2617930/).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__22_May_2010_12_00_03_+1000_t7wWGKA7eBKEqBSB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv3OqMACgkQjjKRsyhoI8zoSACeNClaVWiWJN/o3NQlO6oyPpmD
428AoJgxK1IjqP16MGlRuOS7GUEXjjs2
=PMIl
-----END PGP SIGNATURE-----

--Signature=_Sat__22_May_2010_12_00_03_+1000_t7wWGKA7eBKEqBSB--
