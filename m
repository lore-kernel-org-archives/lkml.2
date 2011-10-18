Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab1JRDfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:35:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1JRDfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:35:06 -0400
X-Authority-Analysis: v=1.1 cv=cRnbtTsVO6wWDdOYuq0VmyuiiLG/FStMSb4CWlTvuS0= c=1 sm=0 a=dOQGOh35R9sA:10 a=5SG0PmZfjMsA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Sy0NQmMnAAAA:8 a=1XWaLZrsAAAA:8 a=qBvDWkJ8qHnBJvCAf0kA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZJmIAeVxK1QA:10 a=UTB_XpHje0EA:10 a=DeocJVjQKA5yTuAT1isA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318908889.4441.3.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL] m32r: Allow use of atomic64
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Hirokazu Takata <takata@linux-m32r.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Oct 2011 23:34:49 -0400
In-Reply-To: <1318908846.4441.2.camel@gandalf.stny.rr.com>
References: <1318908846.4441.2.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7r38eJIeQKZaYI5A/qpS"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7r38eJIeQKZaYI5A/qpS
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Forgot to add my GPG sig.

-- Steve

On Mon, 2011-10-17 at 23:34 -0400, Steven Rostedt wrote:
> Ingo,
>=20
> Please pull the latest tip/perf/core tree, which can be found at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
>=20
> Head SHA1: abcefec31e3dc46554ee9c04f70c6012b17e8dc5
>=20
>=20
> Steven Rostedt (1):
>       m32r: Allow use of atomic64
>=20
> ----
>  arch/m32r/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> ---------------------------
> commit abcefec31e3dc46554ee9c04f70c6012b17e8dc5
> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Thu Oct 13 10:40:16 2011 -0400
>=20
>     m32r: Allow use of atomic64
>    =20
>     Atomic64 is now a valid type in Linux. Archs that do not have their o=
wn
>     version of atomic64 operators are to use the generic operations.
>    =20
>     The m32r architecture needs to define GENERIC_ATOMIC64.
>    =20
>     Link: http://lkml.kernel.org/r/20111013085936.GA13046@elte.hu
>     Link: http://lkml.kernel.org/r/1318516816.12224.12.camel@gandalf.stny=
.rr.com
>     Link: http://lkml.kernel.org/r/20111017185440.GB5545@elte.hu
>    =20
>     Acked-by: Hirokazu Takata <takata@linux-m32r.org>
>     Acked-by: David Rientjes <rientjes@google.com>
>     Reported-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>=20
> diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
> index b92b944..6c4e9aa 100644
> --- a/arch/m32r/Kconfig
> +++ b/arch/m32r/Kconfig
> @@ -10,6 +10,7 @@ config M32R
>  	select HAVE_GENERIC_HARDIRQS
>  	select GENERIC_IRQ_PROBE
>  	select GENERIC_IRQ_SHOW
> +	select GENERIC_ATOMIC64
> =20
>  config SBUS
>  	bool
>=20


--=-7r38eJIeQKZaYI5A/qpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnPPZAAoJEIy3vGnGbaoAsBoQAOijJ3uHfhMLbAG2VR2l/Oho
3wA/OPhvKyap49dLx/n2QfwSbh/IqddrEc1u7T2Q9zItUWXgeZfeGsPqO8ndGupu
SgMITLUTcpSf1muQmI+CnyCRrK7w54mQ16+YBo/yS6iYW+Eb7133y4cxvTBbG4GB
ztYguX7GBmInpu8yae0OWdHmsaYs70r41y0ZZrOZ0ZC147ahII/44Eqs/Cj9Nihy
R3GxdXLBWDNMLfRdNhHcd4XK0Z6KYnqTE1hucAHfafCEAa2GKJ/3z+1SYYSmtapu
ReiIDMPUADiZFwm8MeqKAMP+ElYMcM/rxHO9QJncOJBzrYy8zntKA0wLqqi5+E4N
UViu93nLuGXGNwa5N2blqWcrB8vRpIR0M5cTsbfAajSDhHd1IGzFO7kEHvo/BVmz
vR70A9UkMPfjhI0ifiv/mpMRZZewv9PbcSYaas0hWHhUyeAQthIt+uzWcppJS6ZJ
ukvDqqXFlcpKUhl2Rj64vX0hUkPmxt49tF+jN9iMYN58nLnYoYIiVM824tOefa4F
rDqylk8ER4BUFhrs1XhsF/pwLcUq8i/VmYJglUgdXTVN5CQ1TP/FHDAiwX1UGPwM
z0y1FXSd19DFkQwBY5MSDsyj7Vp3wBZhnFKfmuZwR1TSaO4U6wMVM07UuABeDWxC
OytFjOEsPnE65xMTUGDZ
=ALvs
-----END PGP SIGNATURE-----

--=-7r38eJIeQKZaYI5A/qpS--

