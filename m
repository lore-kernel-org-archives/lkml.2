Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0HSErb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 00:47:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44377 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab0HSEr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:47:28 -0400
Date: Thu, 19 Aug 2010 14:47:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-parisc@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCHv2 2/1] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Message-Id: <20100819144719.e690c674.sfr@canb.auug.org.au>
In-Reply-To: <1282184898-30599-1-git-send-email-sboyd@codeaurora.org>
References: <201008181428.45029.arnd@arndb.de>
	<1282184898-30599-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Aug_2010_14_47_19_+1000_C/8cy9Vqz1=X_fXL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Aug_2010_14_47_19_+1000_C/8cy9Vqz1=X_fXL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Aug 2010 19:28:18 -0700 Stephen Boyd <sboyd@codeaurora.org> wrot=
e:
>
> +config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> +	def_bool y

Why not just have

config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
	bool

in lib/Kconfig.debug

and select that in each arch that want it?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Aug_2010_14_47_19_+1000_C/8cy9Vqz1=X_fXL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMbLdXAAoJEDMEi1NhKgbsZ5cH/iwiMK4GR/Ccaa/9y8DQ/Tjc
syjOtf+IDUrxBgXrsmXzYu6BfGNpfi0QeF2DwTkc8lxBS5xP/zVX2Kn4JWZv9Yfp
Q59ME2b00JNc0QectvN0fOpa6qgm6EsNjohKs+lGo6gCYwyaWcACS6hZ6b3PL5wy
X9dHfy7JR2eFx2PmurxhGOLONRFR1L4NXsDXqo1uuTGUVGUwRVLRHA7blG20r1Fs
dPmiiWx/kATxWigF/XvU/M67Vh7kIKR0oqqb7wF0lch1jumgdjjsDZDeD5v6KePs
23B8pxvlkFhPldEFxsOUvHsVXMw8FXMb7u+Vzpysuv8+vp49m3Rr14Ug14Xy0+w=
=kZsc
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Aug_2010_14_47_19_+1000_C/8cy9Vqz1=X_fXL--
