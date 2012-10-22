Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2JVGgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:36:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2JVGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:36:05 -0400
Date: Mon, 22 Oct 2012 08:35:58 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/3] DOC: PWM: Adding binding document for via,vt8500-pwm
Message-ID: <20121022063558.GB17181@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <1350643135-13197-3-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <1350643135-13197-3-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:cfA3xmmz052VsZWroJQtSiXzBsR9DYDrh5Se6+qqdCX
 YKiEl7jIvAOCF+Ssfn8RugyM0UrtiRmUoszwDh20hIQt/tAqOr
 cMhNycNTxb11gc0KXCcLKGApY2/ElmjBZzjS+ZHjNuqTiqsYH2
 TAfP4UiUE5gpOW+QHa8T8KGTKofHQlT96zsOg5elB3CR/A7QzQ
 LnpEP29RIBzweh1d3nQelM18otCM39YAjGrsY46JKdpTddsuU5
 +UncaE/m5fZlo9MEpzib5K3zqQoHwtlPquWJ7sV+y9hbY9LdqI
 OTYDxG8IW2lNno9foe46lF+WZsK0MpMoBUX5Sj9nTM8NYnp9z3
 MwB0sGWG5d0QUyB5iRtEVSnqIeV6g+IsNfcjgnhjhcIt+PN+3q
 hGl95T9vo1OBr/SA0rONNIzXSBQYuX++K2O0tyT8WKpNK4Ymph
 e9jOH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 19, 2012 at 11:38:55PM +1300, Tony Prisk wrote:
> Add a binding document describing the PWM controller found
> on arch-vt8500 supported SoCs.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 ++++++++++++++=
+++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt

I think this can be folded into the previous patch. One other comment
below.

> diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Docum=
entation/devicetree/bindings/pwm/vt8500-pwm.txt
> new file mode 100644
> index 0000000..e8ba133
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> @@ -0,0 +1,17 @@
> +VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
> +
> +Required properties:
> +- compatible: should be "via,vt8500-pwm"
> +- reg: physical base address and length of the controller's registers
> +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> +  of the PWM to use and the second cell is the period in nanoseconds.
> +- clocks: pHandle to the PWM source clock

I think the common spelling is "phandle".

Thierry

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhOlOAAoJEN0jrNd/PrOhzjAP/i6cVI9kMmk9xapzqJeY11U8
jrr7epbE3plPZiHF/luIk2f2B7rTm3OsKxr9giTZzfl7Tq9ztoXivRUF4wMewkaK
cYrOA1L1ud9QUmLde+t98I+xhPXcG20uXP3YBmXHwEePzBBad0ZnVLDEktjJY6XC
AX/1/ebWZQ/wyJx2CFmWkRaKbbQH7SuFo8qBasgVcGDg44xiimbwwpmm0Wkj579B
8WKG2C6I85LDGuUusonEbMMK2y5a7e6Xu5aUEJ7zDzkCCGwmXwLuZJCWnafsUAdI
sdJYQ0ag6JNmJj1DZOYpzh8OeC2DAge+Aw/tVS97ute282kS7NZvn0z6B2Toiev9
CLNnanVeCZsfkAIuCMBS5JTLzjM+RH8n54MgSIJHPMHHr0ZAExocy9S5ApTPshfH
4l1YRUpljK5+QAA9CUYb67VTWhpvhes95DnFHU67UxgOI8kDztBrYBuoul1+EhWx
KKA4YgTg8P/VAAIMKFPCM6NZnjrrj9su/I4Uvm7g4vIHF+6fmu1JcMxwnIGbW94L
L8qCrCl7xfTV2kAF+3q27pSTL/8y5V1NLE9nOiPb3YQrqOuaEutLjoNiowT4JJNc
1seDArkgDImmYXTSUviNgxN2HygcQBDkUfEwl2930TVp9i33jnRk22oNEnjQBmKK
fbGHY3rnbaL0PYTEeakQ
=FaDT
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
