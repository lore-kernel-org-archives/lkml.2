Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2K1GMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 01:12:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56188 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2K1GMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 01:12:15 -0500
Date: Wed, 28 Nov 2012 17:12:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20121128171207.e8e19e40f2c43104951d389a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_17_12_07_+1100_d2L0D2y7c/u/MhO9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_17_12_07_+1100_d2L0D2y7c/u/MhO9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
arch/arm/mach-ux500/cpu-db8500.c between commit e13316d60658 ("ARM:
ux500: Rename dbx500 cpufreq code to be more generic") from the arm-soc
tree and commit 50545e1d237b ("ARM: ux500: Remove cpufreq platform
device") from the clk tree.

I fixed it up (I used the clk tree version since that removed the code
that the arm-soc tree version modified) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_17_12_07_+1100_d2L0D2y7c/u/MhO9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtas3AAoJEECxmPOUX5FE+gIQAIyMespqHTC1PrHqpF6A31h/
aljWiqug5iogpB+bDpvznM3TLd/LMndj/dYp0MGkhNuvjbor8CZvXoCO8GhRRXH4
ueHtEAevTP05guWq5sW9HH/Ei5IcBvbO8iPx5SWBM/oa6ghYlfAAqxadt93wCzkL
soj9oXzWyez21NxKu8HU+5TxelzI9VijOSwsGyGOJiYgQIrB1NFVFF1nR9mr6F/j
QMqwIEqWK08jOa2uZ9vr2F43yvW0b48hahTSI+oZzfyKqy7kWJRiMu5N9ZFElQsm
9g9IzVIGj9Q6F1Q9oRIPNqDauT9TmsJ2vT0CNmUH52kUbHVsVqMXBZSD/nne54oM
0ZGTSkGTHoGggHg/VtakL9RWbw4cTG+pP/5uJBwNq3c1llep8FTPDGQ5wJ483Z7a
6KD8u8xmnatYVg911UtPVW1FSxj6foo+nvApFcE4IJdBz354ehl3i2nPh9G0PxJr
pqyN6zZSmpKRv28zqVkbCSYR7QSbCtRDxkP4z4mNOvfDxju9lyka2a7mqm/UgUuP
9huydEl1hZWo8RdjazrkJPMcJsCiObqdYD+zKgXCF/MS4EW29V7BfOVpo7Ql17oC
IXEW8KmSoivUz6+fjzgtu1652fNktw752P7h2nm4y1D9L/nWh2F0NQ4TClMbAwuK
HJ7xR363FOf+JL1e5n8D
=cQIL
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_17_12_07_+1100_d2L0D2y7c/u/MhO9--
