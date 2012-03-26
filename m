Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2CZVrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:47:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38360 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2CZVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:47:21 -0400
Date: Tue, 27 Mar 2012 08:47:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-Id: <20120327084700.3f32dcbf3bba4319944a726b@canb.auug.org.au>
In-Reply-To: <20120327084414.dacbf074e0f4ddd65ff3ecfb@canb.auug.org.au>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
	<20120326161132.GA6430@lizard>
	<20120327084414.dacbf074e0f4ddd65ff3ecfb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_08_47_00_+1100_=7M1LX9bmF8saFK5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_08_47_00_+1100_=7M1LX9bmF8saFK5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Mar 2012 08:44:14 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I have moved the battery tree to after the mfd tree in my merge sequence
> so we will see if that helps.  I really hate having ordering dependencies
> in linux-next (since they change over time and people have to remember to
> tell me and to send stuff to Linus in the right order).  Also, it means
> that you are not testing exactly what you are sending to me - I assume
> that your testing must be including the mfd tree somehow.

And, if anyone else is using your tree as a base for development, they
must also know about this dependency ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Mar_2012_08_47_00_+1100_=7M1LX9bmF8saFK5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcOPUAAoJEECxmPOUX5FEkCIP/3k+LhEwj1CTUCW52gYng3CK
NCBIXwcIjpn7zFi7VIKvx3FKq8ZL0EZXKIBkRlsTFRX5UiRydlFuB55gY57+8qjJ
Ags6HSS4tzJjaTM6tKRXKBqntjKXkkvdjkOBZ6GEcpM+tRayLT7wwGse3wnbgxNo
aOSQwjlt6ZSu3YIX31rv0k2RmAGbnRY8UWmYKTSd0hhmz+zGRcd6mB2BJYT9Lmkb
HHxO0wAdTuei8zScuz1k6FPB0AR+FXiIxr1UZUZmVGeYOhkMiDC+5fhepFJmuUrk
mJriFcJiyo+CHZYhE/8K3IBWk6vs35KcbZ8gjr8iHSuhgH+AZzZb1h6OHwP8cNbX
eAYAB6M3bPjyFQev4og93q3euHo2EoZ/nraxfTIXO3UP23TDnM6nCL0zrIU+sfim
LjpdeyQlvnVRfPepjLZvKjNjLiRhuNHozNQ5QSfFqS5paMiceyks7ml6Y++fJ0Gh
KiH2PWDSwkINS9XfJ0cvV9jBHdjA2pYs2tmcG3aMqR9t6nnyJj1DvsAKz0TXVxXA
sYwebcTOd3jH/UcjEouuh/hgp5zFlzp7hKqLub9YxJbGmhUF5xQ5P1eKyuZRLM1o
pZ57tEhSYvJ2Be62IEN5V4iTH0Ere85wgcpDJWNUes4ir4lP5lbTug1hBCXKsuMg
DcRb64Cbp2rvxH3Kzuz+
=IAdN
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_08_47_00_+1100_=7M1LX9bmF8saFK5--
