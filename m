Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2GCP3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:29:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47539 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:29:15 -0400
Date: Wed, 4 Jul 2012 01:29:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>, mturquette@ti.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clkdev: Add default clkdev.h
Message-Id: <20120704012902.b45769624f8cad63983b5db5@canb.auug.org.au>
In-Reply-To: <1341329015-28207-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341329015-28207-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jul_2012_01_29_02_+1000_M66dDSF_3k3TklbY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jul_2012_01_29_02_+1000_M66dDSF_3k3TklbY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue,  3 Jul 2012 16:23:35 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> +static inline int __clk_get(clk) { return 1; }
> +static inline void __clk_put(clk) { }

struct clk;

static inline int __clk_get(struct clk *clk) { return 1; }
static inline void __clk_put(struct clk *clk) { }

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__4_Jul_2012_01_29_02_+1000_M66dDSF_3k3TklbY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8w++AAoJEECxmPOUX5FEgmwP/3vMHkacVQq2Iggq8Y7vH7N9
PSQoSShDdT8zPCAd/LQiNdo1Ng1F6dMyq8xGRZFi9Hf8g6a5c2d5HzzmpllYLvmk
Vj8IVBxSDd6JYY/FZhMVng21OX712hmlO9ygqZXcI4ZQ2DIskD7z+sOEhzwpa3Gr
FXtqx61KndtE5UTqlGBhQ3irsviyhKZjXUvpmK0MLlAUJd3f+TEKuVpNM/D5lI/h
MN98Je2d0/4LbtDFKGDNxJjDGaL+h4EhPEsSRMeTXlaALPcTd/f935Pd5scnEv2i
0fUEJv+KTLNynxeZ7cDKybz7id1tD6Rt02nALqmyDIGXZ/55zoKw0s8pOMtkUC+V
m6zqE7BpLZQjWdCErygTxJAmEGZIaF95mpEd4aiFwc9zznoW/Q+aivojoVflxbL8
EIrShXK3lCrDh8I/RhWOMhqcDLbxMrsAL5u6ovHSMRHqjB9dAql1oGyVu6zHedoL
GsycgGdj/KXfR5kvopSK4mqaA4+uYTvy6l0jEudFK/e9+zaSf2EJThfxsRQqvq5E
KnaLse8r1Kz1IDkwEyJ7M+G1ylD3gI+dF8aSmp1NBbfEcOYGJlGWMsJZw3LtS+o7
QYajhU5J77K+vgxu0TYQGQTmDqxFSFMGGS/CMzm2FxF5nFto1serrzO/sDueSond
ArU3T5kmYKpxQ/Rt3BZm
=pz/+
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jul_2012_01_29_02_+1000_M66dDSF_3k3TklbY--
