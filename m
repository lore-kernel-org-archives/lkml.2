Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2KEJFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:05:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2KEJE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:04:57 -0500
Date: Mon, 5 Nov 2012 10:04:51 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V5] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121105090451.GA5847@avionic-0098.mockup.avionic-design.de>
References: <1351138153-584-1-git-send-email-shiraz.hashim@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1351138153-584-1-git-send-email-shiraz.hashim@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bT58XhfXIBSAFTIzMOkMLLqWol35Hemu5Zt6piQVcAw
 hxmKkcLem829Mmu5gN6SFKYLKIqVJ4HlPfMLeCOMLJZLgrZGkh
 tQbrr9A30CSA7iYiIPuh0bE8yJfu4J8l8lLlXTv5ukek5eLDXL
 GvdtNIHxi6+ZP3+ZJsfq+O0wSw2K1MhzEPtrmn0Jeyal4ZkZDY
 thw6913Ry+weehpocUstmU+abCXP6SCMW+8ihq2AJm1SzWjDNd
 aYVSeD4ZfCZBWJg9s0N8mcpgGdxcta9WNrEAfgeuI8rjXiqZMO
 04HcxLTSgBEh4NL8pkSnfVyXICVhWwddTRbDZUXWZjmwl9OmQq
 qY624PbgmmhgzWm22PBrD4SU6NTt6Y19AlH4gsJMSX+BDS2pS+
 pKp1ozxvOD751XHAmnk6xeGLIg6XGrmLTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 09:39:13AM +0530, Shiraz Hashim wrote:
> Add support for PWM chips present on SPEAr platforms. These PWM
> chips support 4 channel output with programmable duty cycle and
> frequency.
>=20
> More details on these PWM chips can be obtained from relevant
> chapter of reference manual, present at following[1] location.
>=20
> 1. http://www.st.com/internet/mcu/product/251211.jsp
>=20
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Vipin Kumar <vipin.kumar@st.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Changes:-
> V4 --> V5:
>    * replace tab by space in structure element declaration
>    * restructure probe to register pwm_chip at end when clk is prepared, =
and
>      all initializations done.
>    * move clk_enable/disable in probe under if block which checks "1340"
>      compatibility=20
>    * Replace (ret < 0) if condition by (!ret) at places where ret should =
be 0
>      on success
>=20
> V3 --> V4:
>    * simplify remove
>    * maintain alphabetical order in Makefile
>    * donot check for device node in probe
>    * move few assignment lines in probe
>=20
> V2 --> V3:
>    * remove "disabled" line from pwm dt binding documentation
>    * remove un-necessary check on pwm chip (for NULL) in remove.
>=20
> V1 --> V2:
>    * make proper reference to pwm and pwm chip
>    * take care to capitalize PWM at appropriate places
>    * fix compatible string to the SoC where pwm chip was introduced
>    * Rename the documentation file to the name of driver
>    * Fix cosmetic changes like names, function name alignment, paragraph
>      formating, comments placement and formating, etc.
>    * Group and associate the bit field definitions to their registers
>    * Fix kerneldoc for structure definition
>    * Use chip to name pwm device and pwm for the channel instance
>    * Remove init section qualifiers
>    * Remove ifdefs around device tree from code and add dependency on CON=
FIG_OF
>    * prepare/unprepare clock once in probe/remove and just enable/disable
>      at rest of the places.
>    * Use _relaxed for readl/writel.
>    * Fix pwm disable part in remove
>=20
>  .../devicetree/bindings/pwm/spear-pwm.txt          |   18 ++
>  drivers/pwm/Kconfig                                |   11 +
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-spear.c                            |  276 ++++++++++++++=
++++++
>  4 files changed, 306 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/spear-pwm.txt
>  create mode 100644 drivers/pwm/pwm-spear.c

Applied, thanks.

Thierry

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl4EzAAoJEN0jrNd/PrOhIYcP/27FN5I9HyxkcMllZJNSRRlA
O9HEM8tMir/tpXCa2SGUwa3yq+rP0wBWDXareIBnL7ZVakD0U7d8hvIlJfC14aDM
IZySUu98eB5ueTuFunIo96SwKYO+jCLpxMFS+njWyxf/VlcKhYZHBRaCr236DcC+
prreG70/7VdTrEGxrfmMYl+3/1yIdRuZVMK7e+oJbZc7CY7cbnuRsk4RUVzWDGc+
qJcuHDY5vzBUkLuRvRSBkeJJaOaYDyeAllgPUXXCNzbbCI5UK19ryWl7Lsf8biY3
Sbz+1IWLa2ADG9rv5gvh6qt+bPQyTkSmqgLmv5mi5ePF3otC2fdix1RXdE28AhIS
LX3QHPlCE0zUZ9qleKRPHrfO20+3xzH53lGKCDI6I8USV+Bn/AB9KAIuuM13H/ZG
l2ne2pmKgV03yAwG4zO44spf+bRBw8RJXfk+lKQ8mqc8VwOnd+RRzwaDmjWYFt2A
QaGMT4VxMiGf4ODyqbyJBD4UOPsSjGckIl9fbQ8vUH4DY8dDgZbebTJ7yRQwK8Jm
nm4ts0sr/hFydXIEkX1acY+CGZaYn9DPXyiqqTZYK+00IddmtcYY3mglWh4f132x
6SQwlcwLS6l9ECTMGyIvK/M6WCcM/00x3DKIDtsa+Ma0m+wkjuAI0a6DPFZzuzrM
rfwMfbwefG3bNl2gRwV+
=UFz4
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
