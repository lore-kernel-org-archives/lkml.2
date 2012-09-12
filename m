Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2ILG1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:27:42 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:53068 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab2ILG1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:27:34 -0400
Date: Wed, 12 Sep 2012 09:23:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120912062259.GC18563@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com>
 <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 11, 2012 at 10:02:48PM +0000, Paul Walmsley wrote:
>=20
> Hi Felipe
>=20
> Just tested these OMAP serial changes at commit=20
> e36851d0fa94b0f7802b3cc80406dbd3ef4f2f16 ("serial: omap: fix compile=20
> breakage").  There's good news and bad news...
>=20
> The good news is that after applying this series, the 'OMAP4 UART garbage=
=20
> on long transmit buffers when PM is enabled' bug:
>=20
> http://www.pwsan.com/omap/testlogs/test_v3.6-rc5/20120908202511/pm/4430es=
2panda/4430es2panda_log.txt
>=20
> ... goes away.  (Unclear if it's because the underlying bug was fixed, or=
=20
> if unrelated changes are masking it.)  Not sure what caused the problem t=
o=20
> go away exactly, but it's one of the changes between d37c6ceb and bf63a08=
=2E =20
> So that's good!

I'd point the finger at sticking to put_autosuspend() as that would give
HW enough time to actually unload all bytes from its FIFO through the
UART lines. can you check if forcing the autosuspend_delay to -1
triggers the issue again ? If it does, it's some help from autosuspend,
which would mean we still have the problem and needs to be properly
fixed.

> The bad news is that N800 no longer boots -- or the UART dies during=20
> serial init:
>=20
> http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/=
boot/2420n800/2420n800_log.txt
>=20
> The problem doesn't seem to affect the 2430SDP.
>=20
> Could you put together a patch to fix N800?

I'll see what I can do. BTW, is that log with DEBUG_LL enabled ?

cheers

--=20
balbi

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUCpCAAoJEIaOsuA1yqREnhEQAI9asEuO04CahEB8Dh5jCm5A
VNJ8hg/zvaL4eEtZ4yB2P+inDPogqFCpfdMXnwQJpHNg5jR+TASmsxITOO16q4/R
B2Cv+ayZijXAHm3X2e8GO11X777Usv3bCm8BznNZFBjggDqJfeaIzZVcp+1RkaAQ
VOOKDpvTmj2m/vM4kCWOMynFB9B8i0aIncxXcx/WWguzczvTRq4Q8AfHnJb7HEGH
AWyVHbVJKUbLZvWUujoLgKRjqf6cH6/SHvLHhNUYOuaC4JsPtEVI8G2ptvvVD1tB
ho2OQboA3sQBpzbNGgyAf3qWxl9cO7e2cpGKlaZY39MLYM4TRG3kHtqrDEamnAMU
5nZTvLJaJR1VAeUQ6DHMk2Cx65wd7UP0tAtQFoEc7wTMnVSfp5d1fIVJlBGzPpYW
DvQM8LTYMC3C3n15vt6vksHy3kROXoKoNYy4xvIL7YkAvJIkLbkfwBkLcRpt+WTs
rZdHKPJ/3q5KRr4y3gYEO0+1sn50XBffsfLLfr1D8q0SZ+9n4UHtb/iDAVz/xjrc
GSV3/0ZtZ6i52DnIkwbiYH2CK3kfOqI3V2+cn30KsFxXnLz1QasHMSVoYqW632+m
cein7FgWlgiYtLfNpmLRpSnAjwEFhcjOQAtZuWnOH/X6F9Sr1e+Fgdjyd1Obq1IG
WTD4ChIk3JVFq+RJx0M/
=Twiu
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
