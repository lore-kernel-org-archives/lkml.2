Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2EZMls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 08:41:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41099 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2EZMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 08:41:46 -0400
Message-ID: <1338036094.2525.7.camel@koala>
Subject: Re: [RFC v7] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Sat, 26 May 2012 15:41:34 +0300
In-Reply-To: <1337771191-95358-1-git-send-email-richard@nod.at>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Zxqr9OtDB5vkon/Zhznb"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zxqr9OtDB5vkon/Zhznb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-23 at 13:06 +0200, Richard Weinberger wrote:
> v1: https://lwn.net/Articles/481612/
> v2: https://lwn.net/Articles/496586/
> v3: Didn't release it to linux-mtd
> v4: http://article.gmane.org/gmane.linux.kernel/1297626
> v5: http://article.gmane.org/gmane.linux.kernel/1298488
> v6: https://lwn.net/Articles/498041/

Hi Richard,

while my daughters are sleeping, I have a chance to quickly review the
code. I just start from the attaching path and add TODOs.

Can we change our workflow a bit. I will create a branch for fastmap in
the UBI tree taking v7 as the base. I'll add my TODOs there and commit,
and send them also as a patch to the mailing list. You then send
incremental patches which fix TODOs or anything else.

We can discuss my notes and if some of them make no sens - the patch
would just kill the TODO.

In any case, I feel a need to switch to incremental development and get
incremental patches instead of code drops. You can send entire fastmap
work to the list from time to time, of course, for people to look.

How does this sound?

Also, I'd like you to document the tests you do. I'd like to start
making sure that we never break anything.

We can start with the UBI tests from the mtd-utils plust the integck
test. And whatever goes to my branch should never break them. Do these
tests pass now? If not, let's make them pass.

How does this sound to you?

At some later points we'll start to move pieces to the master branch.

Shmulik, is it fine with you?

I'll publush the 'fastmap' branch a bit later and send you the patch
with my TODO comments, if this is fine.

Thanks!
--=20
Best Regards,
Artem Bityutskiy

--=-Zxqr9OtDB5vkon/Zhznb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPwM9+AAoJECmIfjd9wqK01LEP/0/pBzNd373Bnt84wHX4HNPN
bOTGy1O+dYUGjULtOx9CFECJsbvtUOeNOoLuAAQFC2J8/ZdQet2wt8Sngijze5or
Uu46EqIfHF4fj3uuaM/arji0LCZQn2kCl3NdMWDepwpbPDugaKk195FzjvJEnMts
a9ScrIIviaRPU/PME4oiaL8+9Z2F/eJ3mypEGEklrmi5xkwZUA1eWMzH1eO8RtJV
RH/+fXQ+WSbBORnav27xqWSs/lDI8cw60Mz9WFUNkkO50o+FUSzSwxZtynOwsDN6
QpWqPDF5rvU+RIXxWBTVRQXGLD2OPBQOj0dw0NhdjnJ1RXcbABgwVJsdENeWQVkD
XPaFZB8l8KzZTOV/KPg6k1ePDVuTzbjNG4tSyqc+VsKlmTIIOL6HmZty3A1qkPPI
C12nh2D0SWuJrVF51o+VIy2rQT7Sr3tZubqKzFi2ZD3m3IHAo9Gy1Uglib0Y1TsR
xapjg7KHw1QvVESiLIgh+YvBbZUkXNh9/oG6vN0wdW2fygkK83L0yyrTLG6rt7nQ
AmTk33FlJX6vKd/2se7Kku9krkeUy7gg1Bh1JW+p/oQvx748pBx89A5wH5ZFv8ld
k4iY+VE6h7fbZJV884be4LaqgxRF1XfMrgopr0yk4NVw+XTGUKfltesQkX3zk85Q
AY0Hi1ZliewEflHI4zEe
=hL2M
-----END PGP SIGNATURE-----

--=-Zxqr9OtDB5vkon/Zhznb--

