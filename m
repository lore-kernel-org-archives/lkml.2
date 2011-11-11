Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1KKF6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 00:58:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34601 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1KKF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 00:58:01 -0500
Date: Fri, 11 Nov 2011 16:57:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20111111165741.5a6d5f14ad70f98776d3b39a@canb.auug.org.au>
In-Reply-To: <201111101941.59570.dmitry.torokhov@gmail.com>
References: <20111111131159.848e724c5a9257d0b9f0f0f9@canb.auug.org.au>
	<201111101941.59570.dmitry.torokhov@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Nov_2011_16_57_41_+1100_f.U/cmY1ZUVi5/JK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Nov_2011_16_57_41_+1100_f.U/cmY1ZUVi5/JK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Thu, 10 Nov 2011 19:41:59 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.c=
om> wrote:
>
> Please drop the whole HAVE_SAMSUNG_KEYPAD thing; HAVE_CLK is all
> this driver needs. Expanding beyond Samsung will allow greater
> compile coverage.

OK, I have modified the conflict resolution for tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_Nov_2011_16_57_41_+1100_f.U/cmY1ZUVi5/JK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOvLlVAAoJEECxmPOUX5FEB/kP/0yaEwCF2bliXEO0FCLkHsWi
nqNnaeubr+AiTCJkasgWCAqkYqSvk2BPAKzlLzV4b3h1XSuziuYf6ntd8VpLaiQm
VP4QAtJ3Y5Ckr6tC4Z2BtdDZopDj767h/UWJQA81CPGfNVM/vYu6bONjLn77HsOl
ATutzYK4Zo/D8yCWCu10IdHOlBM+nwySz3RyLVUXDAao1lI7AT+3ALDE+HT6bLe+
9OhEinqlR3bC3F+8sqsfoY2gGVv6Z8ElbWEfjhY7dkx7uccRCubTtg+1xD18+b6B
nFt+fVgJjidgW9JvZST7uv8IAY0VOKcJL0qrpx52rdhV9mk8qBlVlgel3cKPVV3b
6tnO7N7qjpjv9mxEMqeGN7mhdkoSkIXjTCbrmiaUjTMRtKgq+SVJ8t0iCoIKQioh
DWECCIMy4uoRzEKJ1dBdSql3JyabiZhYKjfSiexTk6fvTlEWvctL9PjoYnbRzVF5
vFSNJURrhrDp/E/bIeGvBUX0XliU4CM1B3bDFj58wFJGL94oRxotDU5ZqXaKMpCR
rl3UjrR1rdI6QQX+J+wxN0D6/khPh/ov/huSFTKJppjgW1B+1vMxrRgUErmKZ4/j
NgjKx3hSbc4f1jVEPCkMzhnzBFNM7kLuN/f8iOuWc+f5eFhQwztl2o6L/2A3SpCk
JrUrZIZThhTJUyjm2L/C
=FBUa
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Nov_2011_16_57_41_+1100_f.U/cmY1ZUVi5/JK--
