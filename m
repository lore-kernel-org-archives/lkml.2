Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2IJGOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:14:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56766 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJGOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:14:38 -0400
Date: Mon, 10 Sep 2012 16:14:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Loic PALLARDY <loic.pallardy@st.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20120910161428.879618aea62e5be6340ed93c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Sep_2012_16_14_28_+1000_h=pcJN5oisagaknX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Sep_2012_16_14_28_+1000_h=pcJN5oisagaknX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
arch/arm/mach-ux500/clock.c between commit 79964bcd792f ("ARM: ux500:
Correct Ux500 family names usage") from the arm-soc tree and commit
ebc96db7632f ("ARM: ux500: Switch to use common clock framework") from
the clk tree.

The latter removed the file so I did that - there may be more fixup
required.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Sep_2012_16_14_28_+1000_h=pcJN5oisagaknX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTYVEAAoJEECxmPOUX5FEsIwP/2hFaRn8Vi6kJNA1+GeinZFV
xYwsiwuwhZ2iP+h68GVm6GZBIXDigKXMH9CW2GqlCNXoLErbpnx8SnRdVbZbQ7Qi
RDJT/b9pJOEDtYN8tIcc1LQW6NG9FS32zhkTgGyu0abWMlSlIbqFqhRpcdLzNhY8
UNIXTfOZGsReQ+O6QEg2cdUPzpqU4JpR4yApbyjiSDQ6YbvIp3K4IeSgPIhtrpHo
G06mioMtJPZdha9B9DD8J43dabCiu0KZClnk+kSZ25yVb9arqp1vvYvSod7xFr3r
ts9r5fY94Xbwwc7XvPy37KXjaBu2C8UNxS/z0F+O0PHvi2FOdRSBH5CrYqFSWeqe
Nuw3ZJIvtUa1RnZcC3sXZ6UOqrPyRjW9wTcQjcwwQgCYDeB7mjtHVMSt8DWx74hB
gRjUPLEmjmuvxODmxziP8k6LgvzPPOqDU0bhFNzxI4wcz+94kBDw2mPzeJb2vfFP
i98GgTAUHxDEXVXmpqNeqtlZgjIVrq/yCdLkIs/HWDndBHTzXqIjlUgxEWyjSnQh
zDla7npif7j1kShnAWpw3BtX+2XOXV+jqghzAQxe/5T5UhioHuIoh98wetRBMA5N
km7s5STxtYtSEvNq5Sz9UPxEK1wI9rR6VYz2WcbHUhfXl5r7Pwk0gB3ggcMNLCf/
FtUxuyeu9RaD4jRNjyiH
=xp1O
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Sep_2012_16_14_28_+1000_h=pcJN5oisagaknX--
