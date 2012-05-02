Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab2EBDah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:30:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50800 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2EBDag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:30:36 -0400
Date: Wed, 2 May 2012 13:30:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: [PATCH 0/2] [GIT PULL] ktest: A couple of fixes
Message-Id: <20120502133023.07e16a8681b8924afc47e4e0@canb.auug.org.au>
In-Reply-To: <CA+55aFy02d13HkfwY-TEGwu=2cd8en+_rnrnwcwixGKRmdJRtA@mail.gmail.com>
References: <20120502004439.965120020@goodmis.org>
	<CA+55aFy02d13HkfwY-TEGwu=2cd8en+_rnrnwcwixGKRmdJRtA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_May_2012_13_30_23_+1000_xcAiU27ZMszRbb1J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_May_2012_13_30_23_+1000_xcAiU27ZMszRbb1J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 1 May 2012 19:58:46 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> The sad part is that I don't think you can even override the second
> case. IOW, I think even "git pull --ff linus v3.4-rc5" will still do a
> non-fast-forward merge.

git merge v3.4-rc5^{commit}

works, but that doesn't work for "git pull" :-(  I tend to "fetch and
merge" rather than pull ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_May_2012_13_30_23_+1000_xcAiU27ZMszRbb1J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPoKpPAAoJEECxmPOUX5FEFQQP/i9T+D40bSaM9zDodqfcQcJV
7HM8h/QWUzTa12vfxRe/BazwYSwkEEJBXh7BMdwJLzbsHcYMW/2oTXq9VYn0dwht
FGE5PhjavDt25pfcRvAYqV+zfU39ERokcuIL1JTKgFd+ezJFtMBtwn07WjNAMsXh
NZUqxmcrZ2SJQ0B4OyW+utPNPaNpSSNdsUkdOz0rTsYpuRLr8d0iBKEk37HDa/9Z
gCx6rznx/5CX8RI8VDL0mcOUtbDW5SJiEqHhfa8NzE02HEu5OEFy1gvg1pJgHrN4
o0EIkub8rHLlyq9LpyUPSkoeCDIwlGt0UyEDY+G8ZuEO1W1Cka9dtBKomG4KC9HE
yYvk1/vDh+FVAJM/i9KC6S3je8fm2PmVRFhJz6Y67t5uQkkIueU8wh7S85EiIYby
SIiz78Ft+baP7YX/LGIkpX/iAl5jb5EPU2NfgM4iKUsNB6ViDfeNPNbB3UhJZOME
Ysq+56Pbqzi4JwuwGa4OtqOUhGVQSpUcjGhcHb+3NYPhYK+1qbKxutB8e+bYzepp
UVTJOC9X4dkj0h0Xny8rGqvKzvUkRLvrSqLLp0Jo5Dku0cgmPls51dPQqeiDOrRN
MRPU3l1t9rgVsANsowdYClANryhG1zBHClafJvBXgoULfLakRWp5394YJiepiI7Y
xSCbZyEl8N1AJxaLQTM5
=ZMgM
-----END PGP SIGNATURE-----

--Signature=_Wed__2_May_2012_13_30_23_+1000_xcAiU27ZMszRbb1J--
