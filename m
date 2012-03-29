Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2C2FYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:24:31 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:36703 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752408Ab2C2FXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:23:44 -0400
Date: Thu, 29 Mar 2012 07:23:08 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [git pull] cpupowerutils updates for 3.4
Message-ID: <20120329052308.GA5823@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <20120325183807.GA26398@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20120325183807.GA26398@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

any updates on this?

Thanks & best,
	Dominik

On Sun, Mar 25, 2012 at 08:38:07PM +0200, Dominik Brodowski wrote:
> Linus,
>=20
> a few cpupower updates for 3.4 are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/brodo/cpupowerutils.git m=
aster
>=20
> Please pull from that location. The diffstat and list of changes is below,
> the individual diffs are sent (at least) to the cpufreq list.
>=20
> Thanks,
>         Dominik
>=20
> Franck Bui-Huu (5):
>       cpupower tool: remove use of undefined variables from the clean tar=
get of the top makefile
>       cpupower tool: makefile: simplify the recipe used to generate cpupo=
wer.pot target
>       cpupower tool: allow to build in a separate directory
>       cpupower tools: allow to build debug tools in a separate directory =
too
>       cpupower tools: add install target to the debug tools' makefiles
>=20
> Ozan =C3=87a=C4=9Flayan (1):
>       cpupower: Fix linking with --as-needed
>=20
> Thomas Renninger (7):
>       cpupower: Better interface for accessing AMD pci registers
>       cpupower: AMD fam14h/Ontario monitor can also be used by fam12h cpus
>       cpupower: Add cpupower-idle-info manpage
>       cpupower: Unify cpupower-frequency-* manpages
>       cpupower: Fix number of idle states
>       cpupower: Remove unneeded code and by that fix a memleak
>       cpupower: Fix broken mask values
>=20
>  tools/power/cpupower/Makefile                      |   93 ++++++++++++--=
------
>  tools/power/cpupower/bench/Makefile                |   23 +++--
>  tools/power/cpupower/debug/i386/Makefile           |   40 ++++++---
>  tools/power/cpupower/debug/x86_64/Makefile         |   26 +++++-
>  tools/power/cpupower/man/cpupower-frequency-info.1 |    4 +-
>  tools/power/cpupower/man/cpupower-frequency-set.1  |    4 +-
>  tools/power/cpupower/man/cpupower-idle-info.1      |   90 ++++++++++++++=
+++++
>  tools/power/cpupower/man/cpupower-monitor.1        |    2 +-
>  tools/power/cpupower/utils/cpuidle-info.c          |   12 +--
>  tools/power/cpupower/utils/helpers/amd.c           |    4 +-
>  tools/power/cpupower/utils/helpers/helpers.h       |   11 ++-
>  tools/power/cpupower/utils/helpers/pci.c           |   35 +++++---
>  .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |   25 +++---
>  13 files changed, 259 insertions(+), 110 deletions(-)
>  create mode 100644 tools/power/cpupower/man/cpupower-idle-info.1

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPc/G8AAoJEJqXYIlMjaMNM1EP/1WZO3+MmtGCNScfiQdf7lrE
dVnTGbl4Zo/VdqMCmpLDkq6QnOr0VV4bz+8ldp1pGZjucGvQe3E4x9lYg7esj4ek
85bIWkCT7Fxr6KbMNPqmHHUyrCHvsnFClDq3vHCxL6pcfttmLCglAg2TuszTO2XG
loHAyJ7nC6WMCfOXaBOOcvzgQc6d4TxfycZDkOvrOekci1KJU0WIpGBjyldJB74y
MWT13bBNzwpOuKB7lFxK411FPd04x5KBLDRiws6nkDIC3JtPxOuf5TipZy9QXaev
tK/4mF9XyXp2TlCSPZFuIRFO8XiUAAOlSAqRP6egh1Z/RLNm+XYI4O50YGL7EuhA
d1PkDTPiwtbtQbmdagkYMsVxVDneVlkj+zYZ5JezaEOq+49wYDz/8j4nsYNNh5tF
Ixe3qkSVP6l/8CIgNmtXiwZYCiRChdgbjHoU729yPa8CFRMk17RyjiAWVzqU46zy
P6QdIFt3lADfHmG3225hGVwxGodYOzwiVvWcjwaha0QuoMTX4szwwEDhEc8utxm0
whcN1nGibtHS8lZe7O7XmNBJVOajaXv7qt3uEdhEklSK+N0nXuWlV98t9ljzaaMi
ZdbQ+5szKBDL1TJEA/TuTYIuIc8+IZIwdNuPzZyVkdJp+Ys3ELN78MGcW4pBN4qh
/acIQsX9SzEyY23rks4C
=wRVB
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
