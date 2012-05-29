Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2E2Hy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:54:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39536 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2E2Hyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:54:55 -0400
Date: Tue, 29 May 2012 17:54:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eyal Shapira <eyal@wizery.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, Luciano Coelho <coelho@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] wlcore: fix undefined symbols when CONFIG_PM is not
 defined
Message-Id: <20120529175438.0e68273020662870497d8201@canb.auug.org.au>
In-Reply-To: <1338275703-28103-1-git-send-email-eyal@wizery.com>
References: <CAMuHMdVv+g=+A1HHNmWWcsFBQjRXNNA437V6-g80cYq7zRJ78g@mail.gmail.com>
	<1338275703-28103-1-git-send-email-eyal@wizery.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_May_2012_17_54_38_+1000__ogrz5_Pq2HX69wN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_May_2012_17_54_38_+1000__ogrz5_Pq2HX69wN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eyal,

On Tue, 29 May 2012 00:15:03 -0700 Eyal Shapira <eyal@wizery.com> wrote:
>
> commit 5063c201d7b799d6cb36d3edfc2c2c3db3b400e5
> "wl12xx: add RX filters ACX commands" breaks the build
> when CONFIG_PM isn't defined:

Just wondering what this applies to as there is no such commit (SHA1) in
linux-next.  Ah, actually this is commit c21eebb50379 in Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_May_2012_17_54_38_+1000__ogrz5_Pq2HX69wN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxIC+AAoJEECxmPOUX5FEW44P/jH7HvGI9b7bYRUy9Cxbrj6f
F085HW9cGn08LOerb9M5I21l76UDUxuwLM3Ra6Fmf3BtZYsuJ3HT4o/rSc/7G7k0
MdAhSl6Ko3iRM0/gn6+BhJy3HfDV0xRqOuhWN5EPKetN7vEhKn2xGyTn2sLGBiFR
n99jRIiojT7jAmJVHKSJqLNYG/RqjkAjDkl/oPiu3PBPHU0IOsjHX5iLNAmzTyjp
hVnD7AJmFvUuODSumbbLy9g3ngJ3D/UFX2YO18OEmRLog5x3bkz3vkJshoWMExhJ
phsMio/A00PmeNP8u2vPaz/c6wBoX/up6TvzoeFF/vbTeHGdR/X3MMklF39VC7HM
EJHVXx98OdX8m3RvDLLncBWCDoMsVCMc9ZO8iUmgQg+Ir/UtAJyyUJ36CqMoBBVS
jga1vdJNixd5pFr5hZwZUZR6AN9qC8+wOYEGELMOfwKLr6zNNFSdYo6YVyr41jod
jajX21RTrMyTX7Kzn6JtC1ZDs2fiytl4Aw9vcgSaKlNuUK68ZL/qj86r3l+IA+Lj
3NfFbhkt/KfTs41n/4PP56S3sn8ti9248yljT7yIlY72aCq5LkV+eq/nO+LE25q+
97mj2NrSIef6sJ3/ivlSSL79rsh0s3pCtxvf2ZtQtvM6ygF6pgQWBgl6g9EVNNda
+/K2n13VCxTnOeMY/pNK
=REIH
-----END PGP SIGNATURE-----

--Signature=_Tue__29_May_2012_17_54_38_+1000__ogrz5_Pq2HX69wN--
