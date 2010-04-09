Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0DIHVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:21:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52313 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0DIHVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:21:16 -0400
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
Date: Fri, 9 Apr 2010 08:21:02 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.32.9-70.fc12.x86_64; KDE/4.4.1; x86_64; ; )
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com> <4BAB7659.1040408@redhat.com>
In-Reply-To: <4BAB7659.1040408@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7994708.VvD75IU4bE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004090821.10435.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7994708.VvD75IU4bE
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thursday 25 March 2010 14:42:33 Mauro Carvalho Chehab wrote:
> Comments?

I haven't seen this mentioned yet, but are there any plans for a sysfs=20
interface to set up waking from suspend/standby on a particular IR scancode=
=20
(for hardware decoders that support masking of comparing of the IR data), k=
ind=20
of analagous to the rtc framework's wakealarm sysfs file?

Cheers
James

--nextPart7994708.VvD75IU4bE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAku+1WYACgkQ4hGc8zKz77ADOgCggcIOFAcoYnZ2HfabEkF1Z9dt
QrwAn34wB242Z6xGro1mFYNIroDAt3S2
=p3Qi
-----END PGP SIGNATURE-----

--nextPart7994708.VvD75IU4bE--
