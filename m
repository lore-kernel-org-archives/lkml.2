Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0KQAfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:35:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59151 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab0KQAfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:35:42 -0500
Date: Wed, 17 Nov 2010 11:35:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: linux-next: build warning after merge of the wireless tree
Message-Id: <20101117113531.5018d753.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Nov_2010_11_35_31_+1100_fM0SRnNiN1hNCCOf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Nov_2010_11_35_31_+1100_fM0SRnNiN1hNCCOf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_tx_cmd_protection=
' exported twice. Previous export was in drivers/net/wireless/iwlwifi/iwl39=
45.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_isr_legacy' exported twi=
ce. Previous export was in drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_bss_info_chan=
ged' exported twice. Previous export was in drivers/net/wireless/iwlwifi/iw=
l3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_reset_tsf' ex=
ported twice. Previous export was in drivers/net/wireless/iwlwifi/iwl3945.ko
WARNING: drivers/net/wireless/iwlwifi/iwlagn: 'iwl_legacy_mac_config' expor=
ted twice. Previous export was in drivers/net/wireless/iwlwifi/iwl3945.ko

Probably introduced by commit dd0dd411f7178a20ea93a3cfa39123f078a07e25
("iwlwifi: fix modular legacy build errors").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Nov_2010_11_35_31_+1100_fM0SRnNiN1hNCCOf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4yNTAAoJEDMEi1NhKgbsrecH/36/OxChniemnOwTE1y00yC0
jERvi4XPOYb1QaPVNwlRIcuw71nKUXLtA/pqeLmapiA9YpX/oKBdYDjyvfAh2inw
a5SkEdQMv2rWnPPpQTSEu3vTrDXR82yUuZsAmXlpqxd0+VoirwvImwFdTCnzLVrS
l8koSKQvOXvklioZGxnzkxiCI65ZHbo3/kc8ZezoEVdehqPa/3JVYlMXD1QUWZnz
zWjcNhT03dQrfyTvVCr1NSs9ZBkaxrCzSql8ZukgmIAzWD2O7d4ZMkMpAiW5mr6j
fFgLypcEnzaFzyFhdjjh7TqPg70+vThsuXHM0oGtUg+SA4RlOp6gzBFMffI5HG0=
=UvgJ
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Nov_2010_11_35_31_+1100_fM0SRnNiN1hNCCOf--
