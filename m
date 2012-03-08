Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab2CHXpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:45:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49617 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab2CHXpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:45:42 -0500
Date: Fri, 9 Mar 2012 10:45:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: for-next inclusion request: dma-buf buffer sharing framework
Message-Id: <20120309104529.f2c21557c14b07ba493f0353@canb.auug.org.au>
In-Reply-To: <CAO_48GHdCfyqoytN-8Vki9u6VCgn3R=T8LUR0Xs0B7KWEMzxWw@mail.gmail.com>
References: <CAO_48GHdCfyqoytN-8Vki9u6VCgn3R=T8LUR0Xs0B7KWEMzxWw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_10_45_29_+1100_pOdpAonZSGB69XVw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_10_45_29_+1100_pOdpAonZSGB69XVw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 8 Mar 2012 14:28:39 +0530 Sumit Semwal <sumit.semwal@linaro.org> wr=
ote:
>
> May I request you to please add the dma-buf buffer sharing framework
> tree to linux-next?
>=20
> It is hosted here
> git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
> branch: for-next

I have added that from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__9_Mar_2012_10_45_29_+1100_pOdpAonZSGB69XVw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWUSZAAoJEECxmPOUX5FERpgP/iZVHZdQHsSkXkFRcENCR5ba
yxealuwW6xbLoY9n7y3jMopP5nEN+scZ/VBVq8RxJ6VHIKWiW/sr6HQv0IrXt7vO
pnqZKvKONGR8L1/ajXhtq2OSHIOl//vTiQVMTjAk/fe4hdG2EPVd1WLz0n9sJ2j+
HFX33PBJOCgXxTrfibdLDJFGBkLaMYT2uBppV5JFc/lk3KcWU8ZsJPncsbqX4har
fPf6TEekOBfcC+sw3IYKOZoz+qwRqSBPCtU+pHk0ZICI3jq5wYL5qDivo02ea51N
uz1pJSrR7XT44E75WeJuNzRL5isUmKww9HC2GRKj8IL2S5/1wZkl84dIFlCYtCo+
cl+MijfsetBJ0vvvX5Vp2CLrub3v50jGwX6RXCxAafR/vW25/3CZLuzoXV9iXbnw
wugAzSpAoKW2CuyvaafcUztc6SeZHXoOCln2CsI4mVxquAZWmygPdx1he+UC8aFE
ekSZd3xrDxSTlNKJ9a+KXp6UJJnjQKvtI09WZvoBeQHEBd4dnX8zGMXhP0CysroV
gmVJjWI4t1pzSC4F18hWSDEFHQBaH14XXPK4mVkNvlmFsbTX2e23oJWI8+/6MKNP
2Uk8hT5sG4S0M7XAc7+oZCRPhdIjSr4cHmFIO4GGS9+Ku+xJu2bwgK+DR0vd0nVE
gawCm9xCu6xz/XpoWG16
=LtPN
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_10_45_29_+1100_pOdpAonZSGB69XVw--
