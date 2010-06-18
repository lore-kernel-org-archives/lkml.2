Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0FRJ6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 05:58:18 -0400
Received: from smtp207.alice.it ([82.57.200.103]:52035 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab0FRJ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 05:58:16 -0400
Date: Fri, 18 Jun 2010 11:57:38 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] HID: Documentation for hidraw
Message-Id: <20100618115738.c3dfb81b.ospite@studenti.unina.it>
In-Reply-To: <1276832283-12084-1-git-send-email-alan@signal11.us>
References: <1276832283-12084-1-git-send-email-alan@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Jun_2010_11_57_38_+0200_OnVCqUAY+H3u_Xbf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jun_2010_11_57_38_+0200_OnVCqUAY+H3u_Xbf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jun 2010 23:38:03 -0400
Alan Ott <alan@signal11.us> wrote:

> Documenation for the hidraw driver.
>=20
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  The information in this patch relies on:
>   [PATCH v2] HID: Add Support for Setting and Getting Feature  Reports fr=
om hidraw
>   which has been applied by Jiri Kosina.
>
>  Please provide comments. I'm sure someone here will have a better idea w=
here
>  to put this than the root of Documentation/. I didn't see a better place=
, as
>  hidraw is used for both Bluetooth and USB.
>

Maybe both hidraw.txt and hiddev.txt can be moved to
Documentation/hid/?

=46rom a first read the document is OK tho. Thanks.

>  Documentation/hidraw.txt |  283 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 283 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hidraw.txt
>=20
> diff --git a/Documentation/hidraw.txt b/Documentation/hidraw.txt
> new file mode 100644
> index 0000000..7153a06
> --- /dev/null
> +++ b/Documentation/hidraw.txt
> @@ -0,0 +1,283 @@
[...]
> +
> +HIDIOCGRAWNAME(len): Get Raw Name
> +This ioctl returns a string containing the vendor and product strings of
> +the device.  The returned string is Unicode, UTF-8 encoded.
> +

Is the encoding specified in the HID spec?

[...]
>
> +Example
> +---------
> +The following code shows examples of read() write() and all the ioctls f=
or
> +hidraw. The code may be used by anyone for any purpose, and can serve as=
 a
> +starting point for developing applications using hidraw.
> +

Just a very minimal remark, maybe the code should follow the kernel
coding style (early return on error, no braces for one line conditional
blocks) even if it is a userspace application. Being it in the
kernel Documentation I assume people reading it would be used to kernel
style more.

> +---- Begin Code ----
[...]
> +---- End Code ----
> +
> +Document by:
> +	Alan Ott <alan@signal11.us>
> --=20
> 1.7.0.4

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__18_Jun_2010_11_57_38_+0200_OnVCqUAY+H3u_Xbf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwbQxIACgkQ5xr2akVTsAGkWQCgjGsLDYsCBaM/6LOoZ7lFRkTl
TLAAoLBrP5yLRMmys1iNmYeIVM6KNPxO
=+0K+
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jun_2010_11_57_38_+0200_OnVCqUAY+H3u_Xbf--
