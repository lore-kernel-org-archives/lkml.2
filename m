Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1HPGAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:00:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60975 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1HPGAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:00:49 -0400
Date: Tue, 16 Aug 2011 16:00:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andy Lutomirski <luto@mit.edu>,
        Peter Anvin <hpa@linux.intel.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Rule 1 (Was: Re: [PATCH 3.1-rc2] x86: fix mm/fault.c build)
Message-Id: <20110816160036.859d2c65dc1aeb94ad5b76d6@canb.auug.org.au>
In-Reply-To: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
	<20110815101846.58809a89.rdunlap@xenotime.net>
	<CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Aug_2011_16_00_36_+1000_WlTgPpQ5CWlo_wIn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Aug_2011_16_00_36_+1000_WlTgPpQ5CWlo_wIn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 15 Aug 2011 19:09:57 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> Urgh. I *hate* those kinds of "some configs work" cases.

Or "some architectures/platforms work" ... That's why we added Rule 1 to
Documentation/SubmitChecklist.  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Aug_2011_16_00_36_+1000_WlTgPpQ5CWlo_wIn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSgeEAAoJEDMEi1NhKgbsXRAH/ReTkreURZxXeWMBq0uS3yGS
/PqGjTaXUElb8YTD5sH4TItMsIxYE/pStUfA+zr1X2pUjeHh6hMP4FttkDhegxVc
Heb4BQcuyUhhh2/QtJ1LjASC+MXhnl2ExXjPcNjBb6c/t3xRK7/gtNrWPqUiXBTQ
hIVRwyNxGa6LfUwKaUQq9DgBhMJV30V2aY7wxPxKUA3pPL08w5jG76hxSw1lueJM
sld7C0naMU9KZekvd/0HVQBwZuvCNGNan7Azk0xF4fOHW7LHtijY8HmGkaZcAkfK
g7XKh7qlIQ35oZQe0em5L1b1qQuk2Q0vPyhylQRUjOE75tgs0gQyEB71T7Z5HVw=
=4D80
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Aug_2011_16_00_36_+1000_WlTgPpQ5CWlo_wIn--
