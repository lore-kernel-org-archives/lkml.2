Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1FTQG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:06:59 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60665 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab1FTQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:06:56 -0400
Date: Mon, 20 Jun 2011 19:06:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Skacore Systems <skacore.systems@gmail.com>
Cc: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
Message-ID: <20110620160650.GA26623@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
 <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
 <20110620151522.GN14262@legolas.emea.dhcp.ti.com>
 <BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
 <20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
 <BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
 <BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 05:57:31PM +0200, Skacore Systems wrote:
> Oh and I've finally cloned the mainline git. So here it's the last
> try. I hope the TI people will not sabotage the Samsung's drivers any
> way longer !!!

Now you're just making an ass of yourself.

what do you think you will get making such kind of statements ? I just
happen to be hired by TI, there's no such thing as TI trying to sabotage
Samsung's drivers.

I'll fix this one out myself just to make you stop bothering me, but
don't expect me to put your patches in my priority list. If you really
think TI is sabotaging samsung's drivers, look at the big re-factor we
are doing on the entire Gadget framework, involving not only Samsung's
drivers but all the others.

Even though you cloned the tree you still make a mistake which will
prevent me from applying the patch without manually editting it.

On top of that, you decided not to follow our netiquette or our patch
formatting rules just because you think it's "nonsense". If you really
think that, why do you even bother sending the patch to this mailing
list ?

> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c241=
0_udc.c
> index 100f263..b6e1ca5 100644
> --- a/drivers/usb/gadget/s3c2410_udc.c
> +++ b/drivers/usb/gadget/s3c2410_udc.c
> @@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum
> s3c2410_udc_cmd_e cmd)

there shouldn't be this line break here.

>                 return;
>=20
>         if (udc_info->udc_command) {
> -               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
> +               udc_info->udc_command(cmd);
>         } else if (gpio_is_valid(udc_info->pullup_pin)) {
>                 int value;

tabs where converted into spaces too.

Next time, instead of been such an ass, spend some time learning the
process we use to do development. You'll see things will go smoother.

--=20
balbi

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/3AaAAoJEAv8Txj19kN1Tf0H/izQW5U6gUV5x0YHY8B8mQzo
NwuiF2TsAy4DZoIrZqlSQUsJaOIj7xLiAgn2q1qLJO68x1BUe7yUM+2m/m7HnVGH
jL+H8YVIxa7qJv+UzkojDKr5OcMB0mHsmJxE4g8X1HLIgOfAjME5YVmw5OW6Ptli
AsiODdOOZINLNDoIUgqQ0AGH2ret8ea1kC7WQJGXSqXA4Iur7kbK7IkYgv7e11zZ
fsmH4Hv8axXe4ZvOCLFvS5mrP4k8hw2xQPa0pSATugKMoUrggQB5xmYX/10DZBnJ
qxaiq8HiBm97Up8kiWmFy2NL6/5psfMhGHzkccZkdB9GtoDF0FasIFuhHs55tdk=
=G+SW
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
