Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330Ab1JEVnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:43:04 -0400
Received: from home.keithp.com ([63.227.221.253]:41794 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab1JEVnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:43:03 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "terraluna977\@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
In-Reply-To: <1317849643.25371.YahooMailNeo@web130122.mail.mud.yahoo.com>
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com> <yun1uuslfhg.fsf@aiko.keithp.com> <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com> <yun4nznmbxk.fsf@aiko.keithp.com> <1317849643.25371.YahooMailNeo@web130122.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 05 Oct 2011 14:42:59 -0700
Message-ID: <yuny5wzktcs.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Oct 2011 14:20:43 -0700 (PDT), Alex Davis <alex14641@yahoo.com> w=
rote:

> The patch I sent in a previous message in this thread makes it work corre=
ctly.
> If I added an explanation and a 'Signed-by' line, could someone pick it u=
p?

It would almost certainly break some other machine. We could, of course,
use a quirk to make your machine work, but that's something of a
last-resort as it won't fix any other machines.

> Yes, but I have no backlight control: the screen is too bright to look at=
 comfortably.

Ok, so the new native backlight driver works, but conflicts with your
previous backlight driver (whatever that was). Adding support for the
native backlight driver (Matthew's patch) and disabling the old
backlight mechanisms makes everything better. Right?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTozPYzYtFsjWk68qAQj2Qw//YcWK8hj6w0ovc5qb1fuiA0qnmSmD0snK
BsPMZbtMaza9W0WYAlZS79NQ7Tk1dZCt392gNMcZibARVe56NUYqV+MrH/OIkrUI
h9cXjDDI4YeQguR3zg9Dzoi4dFPvAOKGtVziPS2YqzZcCgl8ZuGMk/go+lmxLrFf
wsRRYjJiz75M4XzcoZYXnQ0v8l4ZEb0kLbUc7k8yqPLq/wWBfjtpFohUzCWhNjeI
Q1wJ2XUEgjdzQoEOv5zht1iJbu7/35DwBUSzMiwQia8FPLYOBvxRp09rcag3Q/P2
clsqzVV0L2Ahrj9iQh6UH2aTn0hYsw4Y1qin6aqeHYA402pqWsxXBjzohrN3eNrG
gvN3TJ3+G3o69o4oayzKDKDTSwm30CoMwUXuzaiwo+WY0OoDAZ6BDkpK2s+XLV6X
g5B52hmQPmDiq8NYl3gdvorUK2liuQ9MHjVELj0zuFBCFeB/h0opgD5lF43obyH9
39/UOXC1yPQj21qhieSMOrQTNDBWkv/9LE/i0Iee8nTofU5mkfILt/+QOrHM83MD
pm74rOsqTOqLoj0Jqb2DQEyVuElzN7Kk7mLGqth94uDFLnwr8E849x61+jsZU8uv
+VNYxKD55GXuM5wq25JfuAegzMwF6OZ1BLdHgk3W2QpEXGba3yOyJhFlG5k+WQD4
a2Cavr/0upU=
=otPj
-----END PGP SIGNATURE-----
--=-=-=--
