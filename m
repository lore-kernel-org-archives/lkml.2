Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0DIVmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:42:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0DIVmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:42:18 -0400
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
Date: Fri, 9 Apr 2010 22:42:03 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.32.9-70.fc12.x86_64; KDE/4.4.1; x86_64; ; )
Cc: Andy Walls <awalls@radix.net>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <1270810226.3764.34.camel@palomino.walls.org> <4BBF253A.8030406@redhat.com>
In-Reply-To: <4BBF253A.8030406@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3311773.ZsyI2Y3QfT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004092242.11897.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3311773.ZsyI2Y3QfT
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 09, 2010 at 06:50:26AM -0400, Andy Walls wrote:
> If you're waiting for me to get that working, I'll advise you to plan on
> getting off the couch and pushing the power switch for some time to
> come. ;)

:-)

On Friday 09 April 2010 14:01:46 Mauro Carvalho Chehab wrote:
> The additions at IR core, if needed [1], shouldn't be hard, but the main
> changes should happen at the hardware driver level.  There's no current
> plans for it, at least from my side, but, let's see if some hardware
> driver developers want to implement it on the corresponding driver.
>=20
> [1] Basically, a keycode (like KEY_POWER) could be used to wake up the
> machine. So, by associating some scancode to KEY_POWER via ir-core, the
> driver can program the hardware to wake up the machine with the
> corresponding scancode. I can't see a need for a change at ir-core to
> implement such behavior. Of course, some attributes at sysfs can be added
> to enable or disable this feature, and to control the associated logic,
> but we first need to implement the wakeup feature at the hardware driver,
> and then adding some logic at ir-core to add the non-hardware specific
> code there.

Thanks for the info Mauro.

Cheers
James

--nextPart3311773.ZsyI2Y3QfT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAku/nzMACgkQ4hGc8zKz77CimACePOvNj7FsSe8t5n+Y2mUKfoih
oHoAn3RUdSvZEIoSu65YGypFaqaIMVRJ
=4Vmu
-----END PGP SIGNATURE-----

--nextPart3311773.ZsyI2Y3QfT--
