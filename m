Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2JBPM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:12:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37902 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2JBPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:12:53 -0400
Date: Wed, 3 Oct 2012 01:12:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        <virtualization@lists.linux-foundation.org>,
        "kvm-devel" <kvm@vger.kernel.org>
Subject: Re: Linux-next changes for module and virtio trees.
Message-Id: <20121003011239.3445171ec17e422a289d2997@canb.auug.org.au>
In-Reply-To: <871uhh4cen.fsf@rustcorp.com.au>
References: <871uhh4cen.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Oct_2012_01_12_39_+1000_MhqrEcKkTYqu8wEQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Oct_2012_01_12_39_+1000_MhqrEcKkTYqu8wEQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Tue, 02 Oct 2012 15:56:56 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
>         Please remove my quilt tree
> http://ozlabs.org/~rusty/kernel/rr-latest/ from linux-next, and use my
> git trees from now on:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git
> Branches:
>         modules-next
>         virtio-next

Done.

> For others: beware that these will rebase, usually once after the merge
> window closes (so I can work on a more modern tree), and again just
> before it opens (where I squash in fixup patches).

The first should not be necessary since everything in these trees should
have been merged by Linus during the merge window, so a merge of -rc1 or
later should be a fast forward (though merging with the tag itself may
produce a real merge).  The second can be tricky to pick the right
moment :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Oct_2012_01_12_39_+1000_MhqrEcKkTYqu8wEQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQawRnAAoJEECxmPOUX5FE6SoP+wctU7Y01f/eNenOQ5Jl1q62
zFQyqq+3gLnunQmnUN9Eo3qgtJSFKHRoUxjVPPfrRV5+gl0p4/zX/iQHx4BjrvMe
Dpx8iSBO/UWA1UE5mLi16ZnH63yO/dkvL9KtWmGifggDYnxGjjjpFtinm0LDJB7r
3HBjRGXJdMZu4ESWjnnF3ufBI/MvI4IYgvcbrR/JARKtDobBNAQ0WaxRUWriS0fD
whC28kGg+qrLDY7k4XsmC479oAl5l0K4mz8UaKlkp3HUQ0bKAOfOTDmRBLWWF1tL
afKQ1/BAoSFaQ1mf9IhgdT5Ubrbm5N3jst/E2Qg6FuL7vFV5tN7f5a40AumOXdry
GmPewFI6h6OQd1TFmbSa0LlcBEN3d8jG0j71PcVsi2BRCMUovzitUUuEYZoP54+F
CFnyzfXB1sanHhxmFSzhzC++5fqnQWX9y9v4UAXLlb4AuNI5GUyI3Dw9RPf4jRLI
1P3FjZnsNiPme7ZOLIjS8askQH1s7Zs3gfgCJAD0KDvl7ZFT1NhL1osUAqC/kdGi
ixkUW6PAlJ+WAHubXgrUeEoDAildk739hNclB7zZq9Fl2HQq7kSYmX3nUKDSiEcX
ud+h0f08hbIktWBvFaCzLQUQVJNsKRfwbnUI4ftikpdqzV2DlRHpXHW+uZEnwT6g
1Brv8erQB660Qi0+aIXo
=wFpj
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Oct_2012_01_12_39_+1000_MhqrEcKkTYqu8wEQ--
