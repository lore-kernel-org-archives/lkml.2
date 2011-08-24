Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1HXI5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:57:46 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60685 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457Ab1HXI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:57:42 -0400
Date: Wed, 24 Aug 2011 11:57:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 1/4] usb: Provide usb_speed_string() function
Message-ID: <20110824085738.GE12549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1108221705040.2192-100000@iolanthe.rowland.org>
 <op.v0mv05vu3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
Content-Disposition: inline
In-Reply-To: <op.v0mv05vu3l0zgt@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 22, 2011 at 11:16:07PM +0200, Michal Nazarewicz wrote:
> >>>>+obj-$(CONFIG_USB)		+=3D common.o
> >>>>+obj-$(CONFIG_USB_GADGET)	+=3D common.o
>=20
> >>>Will this cause problems?  For example, what if CONFIG_USB is Y and
> >>>CONFIG_USB_GADGET is M?
>=20
> >>>Also, it seems a little silly to have an entire kernel module devoted
> >>>to a single, little function.
>=20
> On Mon, 22 Aug 2011 23:06:43 +0200, Alan Stern
> <stern@rowland.harvard.edu> wrote:
> >You could do:
> >
> >	obj-$(CONFIG_USB_SUPPORT)  +=3D common.o
> >
> >which would build that subroutine into the main kernel whenever either
> >side of the USB stack is enabled.
>=20
> OK.  I'll wait for any more possible comments and post changed version
> by the end of the week.

if it's only for one single function, wouldn't a static inline in a
common header do ?

--=20
balbi

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVL0CAAoJEAv8Txj19kN1WL0IAKK3FXJPipQyiDQ7XtSpT8NH
O2h+nlUCf/T8IshYaogaX5+J93rSzpWHVj03gYv/M50yzr4hA60+Eex2TEA8ABe5
1wL906G7MGpwAXEDg1zmbIVcxEet3jMyH8XBvRdRSgPrrT/sSkCoSFXs3+DxelEf
T8++8DYxEdBzOaxlbAqt/qstMtB0teaN4eOy9brFlklIWLUSoO91VueP40IvAQGB
T9clPUk7hP7B4o4EIjbei6IykHMrjmnsmwo0deS6+HjU9dQRKFW0d4/SQnPdwE0z
4Q1ADiqYgh/qawx4VOGxwQarwzWBCWnO2qLjlv+NlXP48fzFL9Ha2aeAnyuKUIk=
=Idg0
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--
