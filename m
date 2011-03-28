Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1C1Noy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:44:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59563 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab1C1Nox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:44:53 -0400
Date: Tue, 29 Mar 2011 00:44:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
Message-Id: <20110329004438.d9e755ef.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au>
	<alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Mar_2011_00_44_38_+1100_990dQWYO/6=V1N+="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Mar_2011_00_44_38_+1100_990dQWYO/6=V1N+=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Mon, 28 Mar 2011 14:44:38 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:
>
> I still have some hardware that uses APM and put a new 2.6 on it time to=
=20
> time, so I can take this driver over if you want to. According to git log=
=20
> it's really low effort anyway :)

If you want it, its yours :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Mar_2011_00_44_38_+1100_990dQWYO/6=V1N+=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkJDGAAoJEDMEi1NhKgbszpAH/1cj4tbQpR35E3B/QD0CbDL3
YHebhTa2H672jToibSLDK8GsDLnbt8NimtSMQCrj1tizrjmxd7yXhPvNcEFRkmg0
4DSqN4FGus0PBzD1SAdbV43HWll1hu8ETkvl1dYbt6uEXD8ePAt6FchJQWWNtSRc
0rCPuRJxv7B572SOFDHoift7uw+y8GzMWdiOm8NY5Q4rs1YikiqOX43LDweZHO/+
X18RdGwzNZLfSsVACIIvxDU0qPiVWQkIg6QPWRk1pd2XZ6FR/ZLlRrNZK1D1n0fK
qROEMZ7j1kzjX9bRcQjyk+TOVjX22VXqr9ZKShccJCBq2DKdnhIXDLI0Fqai/sE=
=/rsK
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Mar_2011_00_44_38_+1100_990dQWYO/6=V1N+=--
