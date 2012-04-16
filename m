Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2DPWrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:47:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34481 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2DPWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:47:18 -0400
Date: Tue, 17 Apr 2012 08:47:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Will Drewry <wad@chromium.org>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] seccomp: ignore secure_computing return values
Message-Id: <20120417084707.318091fd28f6dd306e891195@canb.auug.org.au>
In-Reply-To: <1334598461-3160-1-git-send-email-wad@chromium.org>
References: <1334598461-3160-1-git-send-email-wad@chromium.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_08_47_07_+1000_IG3Rt40nJez/TF5h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_08_47_07_+1000_IG3Rt40nJez/TF5h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Mon, 16 Apr 2012 12:47:41 -0500 Will Drewry <wad@chromium.org> wrote:
>
> Unless an architecture selects CONFIG_HAVE_ARCH_SECCOMP_FILTER, it
> is not required to respect the return value from secure_computing().
>=20
> This change matches https://lkml.org/lkml/2012/4/16/14 exactly except
> that it applies cleanly to security-next.  Because there is no
> other difference than the alignment, I've kept Signed-off-by intact.

Given that, I think you should have kept the authorship (i.e. put

From: Stephen Rothwell <sfr@canb.auug.org.au>

at the top of the patch).  Also, you should probably mention the compile
error that this fixes in the commit message as well.

But otherwise, thanks for submitting this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_08_47_07_+1000_IG3Rt40nJez/TF5h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjKFrAAoJEECxmPOUX5FE6jIQAIs7HRmqVsLELtfDaUV1M3MQ
I0Ll3WnEO2ZaIyF8m1rU64VPF7POP/LLcLu1vBXl2JW7Xl/3eqv5xpuWYElcW8FM
Ye3qv5AbLvkPSDtQQrXR8t3p0hMIeL2Eq+Xrf+2KKExnRJYvAMIJfXgkHFN2tROG
kVOz8urSDF5ahgfIRQMu7MS1eTGCGPP8Pk7GJ0LWKWCXDu9D95swxgVZsyfie8ul
T+LKrIYIWie6/9DWGEjM+tWSEd4C0b6dELbX8o9tavee/NaB3IP52vr3Tdb91OCJ
mZe+tk0olh3Dsr/IGJh3wXtjHr+5kiJ0g+B+IMJr9Jr3PO0xY9LINaAPsseFeEps
kitZeEv7J+7tkp/qUcXoK3h5HPOoi3aJhPbjT3QxjM/Lvd/hcObaAXFkXUu3Ca4+
IS8Ep8PKFsKtR2Q9Ws3WIIZwAiMc3TIevM3g0XHwc2O6FNYM3W2j3IiI6AR8KhW7
qNhQ4qNlyJybyPHdggcNMW5uqHvH3JJdrjyX0GCPqQdifPhD59+t9DW7CzGiINO4
zbuR4MofvrsXODlGa2mmA12bKNkAOOmhf1xfG/T5o9yPyESt+FT3EF5vpLTuue04
tnxID805tpHi0GXzDLjWzuASLJ5E3HGcK4TGK6szlzi2wqtxImGweqeN2GulQjoq
bRDVbhw/WT23beGBOLEe
=eC0s
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_08_47_07_+1000_IG3Rt40nJez/TF5h--
