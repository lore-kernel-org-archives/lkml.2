Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1LEINR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:13:17 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33489 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab1LEINP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:13:15 -0500
Date: Mon, 5 Dec 2011 10:13:11 +0200
From: Felipe Balbi <balbi@ti.com>
To: Shimrit Malichi <smalichi@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v4 1/3] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20111205081310.GD9900@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323029552-15324-1-git-send-email-smalichi@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <1323029552-15324-1-git-send-email-smalichi@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 04, 2011 at 10:12:29PM +0200, Shimrit Malichi wrote:
> This patch implements the infrastructure for the UAS gadget driver.
> The UAS gadget driver registers as a second configuration of the MS
> gadet driver.
>=20
> A new module parameter was added to the mass_storage module:
> bool use_uasp. (default =3D 0)
> If this parameter is set to true, the mass_storage module will register
> with the UAS configuration as the devices first configuration and
> operate according to the UAS protocol.
>=20
> The number of buffers used by the mass_storage device was increased
> according to the number of supported streams.
>=20
> It defines the API for COMMAND/TASK MANAGEMENT IU implementation.
>=20
> Change-Id: I86ec7f23b15e602b0f46934adbf5824472e59a1f
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/f_mass_storage.c |   26 +-
>  drivers/usb/gadget/f_uasp.c         | 2393 +++++++++++++++++++++++++++++=
++++++
>  drivers/usb/gadget/f_uasp.h         |  430 +++++++
>  drivers/usb/gadget/mass_storage.c   |   67 +-
>  drivers/usb/gadget/storage_common.c |   24 +-
>  drivers/usb/gadget/uasp_cmdiu.c     |  514 ++++++++
>  drivers/usb/gadget/uasp_tmiu.c      |  277 ++++
>  7 files changed, 3708 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/usb/gadget/f_uasp.c
>  create mode 100644 drivers/usb/gadget/f_uasp.h
>  create mode 100644 drivers/usb/gadget/uasp_cmdiu.c
>  create mode 100644 drivers/usb/gadget/uasp_tmiu.c

I wonder how many times we will have to ask for this to be done on
TARGET FRAMEWORK!!! It's like talking to the walls.

--=20
balbi

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3H0WAAoJEIaOsuA1yqREsrwP/ivOIPjzIYTrUon4s5sEY5DB
KrIguEjvfmx2zrHVjDTu9F9gW9VcAX9xOIkESp74rfRJhwjDGD9OaKhIrqSsgBsa
RgBs2zRvlDBQVgHR/isti65dpx17ms6vZafYClYL4Mr5IptGQPj3bB6A3yIwSNmq
gnDq6r+G90MFSgiEQmgvaKLPOzBKJYe9xP919b/oHMlKjjwSAVpZurf63zuQeUJE
8b1x9FmrYuOjbxkdj8GkbJk8dccbaQP2ya0TIfs9aWo4BWxQIJ8ZIwjutp23AdCA
7jfFOAlfBh4L94wKwhVOr4O5+xhZTquQ5a3UI4nxGiarIyJbkpxDVEfUZcnrFAv7
Oaumyp37KOHvJSqc5wSVaK52g8UMkvx+AMpFN0zj7Bx5W2aHUqRd+c1wfeqsKz54
uQCug5jM9Y5H8gT7OpQ6FkiFzT/QtziUfU9D6qMW6VkqW0poyNYZYKK6sCaXgmVJ
xKlvvlpqLB9frm0m0bVxuiptTAwrhHh3xEGsVHWwj1Ou7z5M/1aAEN36Od8IVvlD
GS2q8cPgLmw+Irviosbuk8gEQbYUJvVZIgjUC5w45g2nTGwySB4cst7Uzke7Dkia
t1z9/QGWIxrpjn29N5QkewBoeWDjUg+VNK3jbdfTY7UuQML+x1efj+JMPCGRpba2
TsUxIbn+4JsY+kdWajxw
=6ygX
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
