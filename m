Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2DTAKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:10:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49588 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DTAKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:10:23 -0400
Date: Fri, 20 Apr 2012 10:10:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric B Munson <emunson@mgebm.net>, Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: build failure after merge of the final tree
 (kvm-ppc tree related)
Message-Id: <20120420101012.591b5e64a8939135bf5cd167@canb.auug.org.au>
In-Reply-To: <20120419163535.52c99a34e2664063d654ac4d@canb.auug.org.au>
References: <20120419163535.52c99a34e2664063d654ac4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Apr_2012_10_10_12_+1000_4ZkXsWyQ0E4yIiVc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Apr_2012_10_10_12_+1000_4ZkXsWyQ0E4yIiVc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 19 Apr 2012 16:35:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>=20
> In file included from kernel/watchdog.c:27:0:
> include/linux/kvm_para.h: In function 'kvm_para_has_feature':
> include/linux/kvm_para.h:32:2: error: implicit declaration of function 'k=
vm_arch_para_features' [-Werror=3Dimplicit-function-declaration]
>=20
> Caused by commit 5d1c0f4a80a6 ("watchdog: add check for suspended vm in
> softlockup detector").  This build has no KVM related CONFIG options set.
>=20
> I have reverted that commit for today.

This build failure now belongs to the kvm tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Apr_2012_10_10_12_+1000_4ZkXsWyQ0E4yIiVc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPkKlkAAoJEECxmPOUX5FEj7YP/3/VGzL/3yGKxoFgGniNsGUD
fPoRCF/Zq0QMPYaawziTWQstXp9Jw/vgbx8L5hTk/m7KCK4ZONWJ29gejMvkdb2y
HoU8KHRrXrigFUdsFem7qSb+/EzeGSLAqpJjYtSPldjB3gXepfO/tghy4v0X11t9
3Wck161Ntb2F5AWlaMpMCRsfeSWU5Gu7ci7Ml940qJ6gyJEeFtVFN5CbwrtPDd2A
MB2/1XBXQmTpznU7nLq0ftmYHwMV/CA68av3bl9smq7rv3zCOZ0nMo96RfJsA2HE
yM4tpVxNnim6WHGvr7vLf3RbEOKKEeGVn0hG/D8j6OIqO+a1aJtgyqT/9JLI6NwL
kW5kFGldilVxihzj5ElXLtUGbJOE6HF10CeD1VxYneNuwW+waqmS7u13pQDFTNIY
+sWdZr2qOzkPGgXdlg/lBfuzGX0UQe39DYTy0xDMu6XgETwRFfScCSzPBpoFeL6H
g2LVwZ0vxT8yuDt1WbvSOsynU5kkUYuKYXkv815pHZNSszEZXpay71qA2c0fIs4e
nWqG4kXaGtj5r80MLzckb8VBP8sK75UgT0aqBKLJU9q7dWsmuDbJ6GOqSbaAFkKy
ZV0eoMINXYS0AlqFGwQNNQGiOm4A8qIMqnv0c6R2G88j/rdnTlOnbwFjPQ9aPfiM
yxKauexRjK70IHMSpnoV
=9KWV
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Apr_2012_10_10_12_+1000_4ZkXsWyQ0E4yIiVc--
