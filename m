Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1FUFKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 01:10:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60399 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab1FUFKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 01:10:50 -0400
Date: Tue, 21 Jun 2011 15:10:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaliy Ivanov <vitalivanov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Roland Vossen <rvossen@broadcom.com>
Subject: linux-next: manual merge of the staging tree with the trivial tree
Message-Id: <20110621151044.5d4330e2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Jun_2011_15_10_44_+1000_2pHk/1yzNeHklsGN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jun_2011_15_10_44_+1000_2pHk/1yzNeHklsGN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c and
drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h between commit
e44ba033c565 ("treewide: remove duplicate includes") from the trivial
tree and various commits from the staging tree.

I think the final versions in the staging tree supercedes the change in
the trivial tree, so I used the staging tree versions.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Jun_2011_15_10_44_+1000_2pHk/1yzNeHklsGN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOACfUAAoJEDMEi1NhKgbsLFsH/1/HMM0AnFf5DtwL4ZwjoWqy
dDDgYjppjyAe3xRgKBbhtKxRYo6ENPMV2xwzXr8i3k1FM5XZFXGjCRVeuP40SljU
MKjPtiPPp1+Q5IovrpBNzBYxW838aE4lPOT8/GP5ySv57vvNRC11+2fzONMIKvk+
C+SlboIq2V6EDwiufnHSChmJE0YpxkPvlwysvw/V8LO1mKztdpIyDyY8CbZeNMUB
SJiPMpY0i7azd4bm1kIbJOdXNqjBdoHLHWqsg9OqnpnV18AnbJfGOf1K7rw8Fk7z
5rHlaJSA3LieXMUXIyrEOYhEoilVAwcgPckffPw//zYGgQce9K5zhCZHQygSH8w=
=xLCj
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jun_2011_15_10_44_+1000_2pHk/1yzNeHklsGN--
