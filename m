Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1KWWHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:07:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:41464 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1KWWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:07:11 -0500
Date: Thu, 24 Nov 2011 09:07:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>
Subject: Re: HSI framework for linux-next
Message-Id: <20111124090700.9ea32aae4722035f20b09867@canb.auug.org.au>
In-Reply-To: <1319794066.28874.22.camel@groo>
References: <1319794066.28874.22.camel@groo>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_09_07_00_+1100_lqxHbpNmjQBk/1mb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_09_07_00_+1100_lqxHbpNmjQBk/1mb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Carlos,

On Fri, 28 Oct 2011 12:27:46 +0300 Carlos Chinea <carlos.chinea@nokia.com> =
wrote:
>
> I have been working in an HSI framework for linux:
>=20
> https://lkml.org/lkml/2011/6/10/280
>=20
> The framework is in good shape and is currently being used for some
> people so we would like it to see it integrated, if possible, for 3.3
>=20
> Latest discussion for integration:
> https://lkml.org/lkml/2011/10/20/177
>=20
> Therefore, could you add the following tree to linux-next ?=20
> 	git@gitorious.org:kernel-hsi/kernel-hsi.git for-next

I have added that tree to linux-next today using
git://gitorious.org/kernel-hsi/kernel-hsi.git as the URL and just you as
the contact in case if issues.

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

--Signature=_Thu__24_Nov_2011_09_07_00_+1100_lqxHbpNmjQBk/1mb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzW6EAAoJEECxmPOUX5FEIPsP/27n2UNVkmt0RMVHB0QvAWdA
mS4SUuZX6Wk4qC+55QECmx0sv9SLl6+dsbp5EZ+eCqqTVoafR1bJolHayFU3BkmQ
gvLULSIvtOjY4Jb29+DiwvQUflCjvKDiAlcxPHBP8DAVE/PFnCmgckNEI44zKySt
6qlYfmr2SB9+29QZi8PIHkDrWLyDXS5Jj+o98GXDmpTzfAlWMeCrkgHUYNJx1J41
iDTK23f4v1tNbvcDJUsw3dBJZtMiFoM2rR3p0t/iEMaXRsFxFtpqTNAB3od6/t21
9ZhFxnbaPLcpe0I/ibbuMlbB6td+LFNv8CtpuUCY/wtzL6YVXK1zodyGGdJHtBVG
qEoKU1iT3CECaMEPA6z5l6uZ7yTr2GeDLk7gGNxmC5N6L6ISgd46Nw/VcSBb0WqB
xSI4cILGkn0df/R5o18K4QNV5YE5O21wcNQ0Kb1HygGyduKDeTONn9KabU3uPz3a
THm5amHtO9jV3Z3rsxJKwAB6nls8L5Ie3lAzdMoA8UL/Z1yVWmTMq1N9sP6gMeXc
8IiIqUDGApayU9J7ZVELhd5QwV5KS6wKNO+z1grx9NfSul3M50qf6NRJZEawvdsV
g1jII86KrFS20ofWFW4i1tCDzWdSl0iFPppKGD7k0GvddXZxtcAjZxbYfWZySKHW
pOAs1o9Q5SeIYC8buVes
=u0s0
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_09_07_00_+1100_lqxHbpNmjQBk/1mb--
