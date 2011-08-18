Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1HRV5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:57:23 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35883 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488Ab1HRV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:57:20 -0400
Date: Fri, 19 Aug 2011 00:57:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ARM: davinci: da850, omapl138: share the
 davinci_uart_config
Message-ID: <20110818215715.GD21064@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
 <69e35d4eac3c4a52d7896bc18c69b4578d1b15b3.1313702401.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <69e35d4eac3c4a52d7896bc18c69b4578d1b15b3.1313702401.git.bengardiner@nanometrics.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 05:50:50PM -0400, Ben Gardiner wrote:
> diff --git a/arch/arm/mach-davinci/da850-reference.c b/arch/arm/mach-davi=
nci/da850-reference.c
> index 25df6476..e4f5072 100644
> --- a/arch/arm/mach-davinci/da850-reference.c
> +++ b/arch/arm/mach-davinci/da850-reference.c
> @@ -20,3 +20,12 @@ int da850_reference_add_preferred_console(void)
>  {
>  	return add_preferred_console("ttyS", 2, "115200");
>  }
> +
> +static struct davinci_uart_config da850_reference_uart_config __initdata=
 =3D {
> +	.enabled_uarts =3D 0x7,
> +};
> +
> +void da850_reference_serial_init(void)
> +{
> +	davinci_serial_init(&da850_reference_uart_config);
> +}

this looks like it could go to that da850_devices.c file (or whatever it
was called, sorry forgot the name)

--=20
balbi

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTYq7AAoJEAv8Txj19kN1LmoH/30cjcm8EQtLZq8pmloKdHN3
bU884ZKIcS1nd8aeeb8gIGT942jug588hiyKlR/jxnd0Vu4WiLfgDjjV001C1QIy
W3K/cHFisYfHtNCfOWpCnVRBDeaX06L2pkEFJL0aD5cA4RR9g07C6OfVapQ3a7X+
XWJf/dPZQabLXM10a2nxeeB1ywhK1KoLVdJLUmbDYz9QygBCfyB8KufAfmTpHd3R
BZHyjrLTTikHMSQA8/PusedRw0ukq2kfR/Ure057ZJlKWR1Nzjn1YYZs/68aSoVY
2RVo6ekF4XRb8h30wpgByMTBUBMF4oCv7cJQLdP0c54YijqFnn5G8klRMvLFKvM=
=z8sq
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
