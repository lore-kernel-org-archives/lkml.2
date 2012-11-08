Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2KHTgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:36:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59403 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2KHTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:36:44 -0500
Date: Thu, 8 Nov 2012 21:30:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121108193034.GB2962@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50929233.7030609@gmail.com>
 <50967BFD.6000308@gmail.com>
 <20121106112751.GD11931@arwen.pp.htv.fi>
 <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
 <20121108140649.GD19533@arwen.pp.htv.fi>
 <CAOUdcc_9UTZpdu6k7wyQc9Hjmv-0YgAGiwsm+NysEmS9VUxu+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <CAOUdcc_9UTZpdu6k7wyQc9Hjmv-0YgAGiwsm+NysEmS9VUxu+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 08, 2012 at 08:07:57PM +0100, Dmytro Milinevskyy wrote:
> > On Wed, Nov 07, 2012 at 02:14:00PM +0100, Dmytro Milinevskyy wrote:
> >> Unfortunately I have some issues with git send-email.
> >> I've attached the patch itself ..
> >
> > I'll apply it like that this time, but try to figure out how to send
> > patches properly. We have some very helpful hints on
> > Documentation/email-clients.txt which are hugely underused ;-)
> >
> well, I try to follow the rules as much as possible as long as tools
> work ... =3D)

git send-email has thousands of users and it works fine for them
(including myself). Maybe you just misconfigured it ?!? ;-)

cheers

--=20
balbi

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnAhaAAoJEIaOsuA1yqREnqgP/iqkoud/D9ric55IYtTt2e+7
nd+k0MhnaGgc4kmg6/FheNNS2TnVjpI/aRD2CbNBC6Ndxxo+mG+PrzKbZ8q7coQe
B1YU7HP/OctDfl8rGfNEqKHaurhTAFRMTTgptSzPzskXv/sPmrFKkHcHgDC7mCEV
24+j4IKsCjxhcnzjvs116q/wfAkwok8+K+SVHrpaHcbXayvS4KL4SsZ9PtPZBnac
De+EGaNGCh8JpDriLpf/kEtbT6Wwz0Dgnn27JFzxrJQgzZOZZQwq6nyhB/BoKMqa
31KaUqM8nHwAeVYR47AiSpjL82G+PyUDjM7Fn+BF0To+fyzdADPX2w0IzI+sAxih
4IZc6hdpyrVz84p5MYoUuI4u4Y8BKD3hFnbkqNz5V0so23vB0mhvxes/0uyuA0XP
a9fl7F2zJoV6tBYcuZYonkiTGj9WHcoc3mvwnUPEztCFhi/vYPHC3JOxoGV13FRs
IpT6Z6ydBnTySFbfcmb+tfvHi3pKLLmRkjhhgdsWqdOEzwuv5qGTYDtHavNnoDc+
+BGiIP7h8zwdkGSB/XA0VwoyuXbKRmSEMGNVDCeWT7v3L+5iUH0mnchJ/2wvvt6c
QHZgxg3SSX/uYyawmUf6OVfTMWuyHu5yXABe5+zdG5tBqj8vDXdx5s0TDh3hrk3x
xh47/tHdbW1hwR5MZSJS
=+rLS
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
