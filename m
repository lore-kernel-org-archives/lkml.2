Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2KHOM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:12:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54954 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab2KHOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:12:58 -0500
Date: Thu, 8 Nov 2012 16:06:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121108140649.GD19533@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50929233.7030609@gmail.com>
 <50967BFD.6000308@gmail.com>
 <20121106112751.GD11931@arwen.pp.htv.fi>
 <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Content-Disposition: inline
In-Reply-To: <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(please, never top-post)

On Wed, Nov 07, 2012 at 02:14:00PM +0100, Dmytro Milinevskyy wrote:
> Unfortunately I have some issues with git send-email.
> I've attached the patch itself ..

I'll apply it like that this time, but try to figure out how to send
patches properly. We have some very helpful hints on
Documentation/email-clients.txt which are hugely underused ;-)

--=20
balbi

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQm7x5AAoJEIaOsuA1yqREBD0P/1vIUr/fxsWJcah2PDFU2Md3
Q4CTfjT683r0NHtWKKCHt0Fh2XNJcI9i3Ayuc2dbqul817n2D/W+wGJX6GKbJjVf
v+K9hBhvVnZNU9pmYMACkNjw2pC7GTucAOyC8XQFbqJLZaaDD1c4fvmmTG64UqQ8
1MJSY1SP/jCKjlW8Q0H+6RW1Eesh9STB5z7cZtqZtww7G8VCMKTThHQBdQMYwnit
X0iSWUFhuEquQsmzWNcpnmMhck9GAY+OuNXlpd0CIWBVYKWkKTCLEAC/SQ1mdj/j
oNxo2iUWMi8xbRxlofznQL0h7sjvAcnWx9ABBMojsYk4j93JNtmX8pRlP3Bwt02V
FEDYSeKyNSpHKqchMJ3RVCX1wCJq48MoSm9b6bS6cv2qkE8NO4L0v+BB5tnNtBSR
6oEzDXq8ny7CamLj8J7pSrQJaOZNagCD8PeQ/d4ilHlshDkl3XRtZEwk4zqjg7vS
h3uCn+QvGXWDCOcZ0J47XPuT7ZZGFCvc9NozyxHxtWT4w02wVEQu/30/8971F7NX
dGKl/DTZPFvK7luNnowPM842VMJbzqzuxxmq8cWMTW2QM1rMH98tkCu7AXIYFUQl
ZitDy7ssSwNrgHkXUcyT929qLxeM/NFo754Fl3VLGKYrxU+CfdJpJb6/RzVT72YN
u7xUMAp36cExWWdgZLF2
=gVvW
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
