Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1KAGC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:02:56 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38510 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1KAGCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:02:55 -0400
Date: Tue, 1 Nov 2011 17:02:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
 tree
Message-Id: <20111101170251.30878c7f7ce73c863bedee95@canb.auug.org.au>
In-Reply-To: <20111101051810.GA7519@gondor.apana.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
	<20111101152312.5751b7ac8b4a998b6ef867be@canb.auug.org.au>
	<20111101051810.GA7519@gondor.apana.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_17_02_51_+1100_78RE=y/XYJe3IUDf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_17_02_51_+1100_78RE=y/XYJe3IUDf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Tue, 1 Nov 2011 16:18:10 +1100 Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
>
> So did the change to depends_on fix it?

I have not yet had time to test that ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_17_02_51_+1100_78RE=y/XYJe3IUDf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr4uLAAoJEECxmPOUX5FEUiYQAJsC6pgvjmQN77QyUlKBD2D/
XZZxX/MN0aPTxqVKS0gU1JPCRM/bxaBLaikxOUyYp5MqJ7MNsIgOHPT3LjSVKoGE
YuT1nTcmUf75J5CfjhAlH7WH8YNP1Vi14FXjDVoK1G/ifY+JmAWqydVr44w8mcpP
nu0zy7jmGKsR2m2vPr/IxEzaLO9punRiQ6LRRQOyepJuV3G7tgyC2W2HUjuN/1S0
e0dI/xgzFinRDLLqJn9Oru5cgWLfGG82hAL/0gbpQPsSrYG07Zv/XUJTS5DIZnej
TKvvJXSHU7sME3buMCbAcE2MHHAkRXnn0GUa4Pubqz/7vMb5e6LRNibgGNn3t4P8
a0UiChn6/sCVDtkqBLajI3oleJSVcBuQmNVydMKUQuwEEWMHeNgNdGg2P/71oh9E
gXYZJEFFWv8Q4ZKj76CqRvoiuM9UQVfbxjRIghGOMf2xDydZmTvn4FsJ9sQ8HuKG
m+mATERpVoIhmcIIf+aM3QPNdtszCpgpoXSNyyrwfyxsOlp8PJpUvPTImlmIbt++
XytOyajfZb2ISt7GXaqiS94KPV7ovcbsqQHncH/EThLmXf7kQ9eYPavp+ZvxEyxJ
HIKUqlbgvHC7TXHsIs1iAcmAO1wV2yA5oenLrzcmS+pEreePsbEqKcXHGwZcgxk5
YYncENYp5aiBC2C2YEgs
=eiHa
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_17_02_51_+1100_78RE=y/XYJe3IUDf--
