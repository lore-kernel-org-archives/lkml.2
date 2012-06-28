Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2F1Cl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:41:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33095 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2F1ClG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:41:06 -0400
Date: Thu, 28 Jun 2012 12:40:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Franky Lin <frankyl@broadcom.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-next tree with the
 net-next tree
Message-Id: <20120628124049.15ee2861836495a252ea188f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Jun_2012_12_40_49_+1000_6G88y=guqRHKOXmM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jun_2012_12_40_49_+1000_6G88y=guqRHKOXmM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c between commit
2c208890c6d4 ("wireless: Remove casts to same type") from the net-next
tree and commit d610cde30b00 ("brcmfmac: use firmware data buffer
directly for nvram") from the wireless-next tree.

The latter removed the code modified by the former, so I used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Jun_2012_12_40_49_+1000_6G88y=guqRHKOXmM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP68QxAAoJEECxmPOUX5FE/pwP/2O6qslKuRAyOpTswwN74/v+
F7SZ93fg/OB9X/LNFQv5yqwgMgmBmt4lI41cEg+5m5QZWgBeUeU+zzzURV/I9bAX
lif+Hfsc7ygSOffVb5VNNNHZBQxZidmBuhvleXk+uqAPQ+yjntrK8C2x70lQOr29
QSTgGgoeqCvWWyeq4F9t7IzA8yxqBBGhaf1VuL0YlP0aXhUxQ059yOWfq7cyBAeo
FjVzFNCzqO9b9SdOcxPg7Iba7+5kVICmKgbcJjjtG7hFe7B2l4MT+0mbqJplRhSC
6fXeHK4ItlM9F9p9CdBmda57Ux8T6jLTdmLnfUeY3hlo/kbIH8hOp6yiLVK85HiP
T7HA6RcMg/uiFkSB2h1oYCUOpDX2tJY4PL2n+oXCZTpVEqUYaslYbTyuOUlupDvF
eVJNleDALy7MvTM8VXkqzZmRboZM6kHM9kSdbyUtOMUPSNOA8FxYhLUm81IneLzH
Cv/jHcDy+PVj0EXpREHutqbYFz8fwJQudATqI+Y1SgwHFwZ9miybpFftYEEnBVRW
Jr+aDWEyKE9GAqZ3otwoB7MPlp3XLyIhmCW0flsKo9hfkq2EAwo6zSpvS2o3t5nc
8KkcsCoFEiYsruRqNBj1Ip7S2H0ESk/4Mim9WC0H+RZovbFXIe92XFmB/6PE0N4y
BbIOpsjW9YmRQIrZ528x
=KG/9
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jun_2012_12_40_49_+1000_6G88y=guqRHKOXmM--
