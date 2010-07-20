Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885Ab0GTBIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 21:08:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51390 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab0GTBIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 21:08:22 -0400
Date: Tue, 20 Jul 2010 11:08:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: writable limits into -next
Message-Id: <20100720110814.ffe72bc0.sfr@canb.auug.org.au>
In-Reply-To: <4C448344.9020807@gmail.com>
References: <4C448344.9020807@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Jul_2010_11_08_14_+1000_I5idg0/U=nt2X2BN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Jul_2010_11_08_14_+1000_I5idg0/U=nt2X2BN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Mon, 19 Jul 2010 18:54:28 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>
> could I ask you to include wrlimits tree into the -next. I refactored it
> according to comments and will try to merge it on my own (as nobody is
> willing to merge it apparently).
>=20
> It's at:
> git://decibel.fi.muni.cz/~xslaby/linux#writable_limits

Added back from today.

> There will be merge conflicts in unistd files with "unistd: add
> __NR_prlimit64 syscall numbers". You can take a look at
> http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=3Dmm.git;a=3Dshortlog;h=3D=
refs/heads/devel
> to see how it looks like in -next.

Not sure how this is useful as it is your mm tree?

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Tue__20_Jul_2010_11_08_14_+1000_I5idg0/U=nt2X2BN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMRPb+AAoJEDMEi1NhKgbsrR4H/i20Jovex15IBFen9Lx8qyn7
uC6hTylRGctJiXNZTT90VhhN6YZpdcsT5mdDHpwpCzixVIWSbrPBUc+pWTZa0SYI
lh7X0FdQYAAizhRotS4owu77UaYAXCm4Onof4oxQCBs+Gd5bpW/cpcuQ4KxQgTnK
hVjZ0yFjU2SnVnWqTLk7EHOK7ZO07T2p3TziGkj9ekWjxx0T3NEl0nskaPfeFtwS
2JuEH8FjtGwm7KxwMX6xz96+na+KKW4qqzmhamLRfKYZm4sMm9uRNpu2M34tLT5G
j7M0p56Ci2lbG2mvsDdmlia3BFS7TM4L05ywME4u/9oi2+ZSVCG2vOdXcT2otvA=
=wbDU
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Jul_2010_11_08_14_+1000_I5idg0/U=nt2X2BN--
