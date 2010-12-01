Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0LAAb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:31:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55557 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0LAAbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:31:55 -0500
Date: Wed, 1 Dec 2010 11:31:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Nikula <jhnikula@gmail.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20101201113138.f6146790.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Dec_2010_11_31_38_+1100_DluGYa0p.vKCBp+O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Dec_2010_11_31_38_+1100_DluGYa0p.vKCBp+O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/soc-core.c: In function 'soc_probe_aux_dev':
sound/soc/soc-core.c:1647: error: 'struct snd_soc_dapm_context' has no memb=
er named 'list'
sound/soc/soc-core.c:1647: error: 'struct snd_soc_card' has no member named=
 'dapm_list'

Caused by commit 2eea392d0a28a0a07d36a9da544eb40f81bf4cb6 ("ASoC: Add
support for optional auxiliary dailess codecs").

I have used the version of the sound-asoc tree from next-20101130 for today
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Dec_2010_11_31_38_+1100_DluGYa0p.vKCBp+O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM9ZdqAAoJEDMEi1NhKgbsMv4H/2ghT8wGiHcJTcr2Uhsf+BfW
piQkRDwHqfdhYStPGFVADITSKrdKNF34nlzGrz5xFGMz8lCPNjliI9az02zQ7QRX
R9CtCq1P6SbZkBFixD6doj6e708+QzhzAAgNUDirFVpa7HQPNQuL/7RabkCFRhXv
xu9v7J2SuGsXWGXYIfOfEXjrgMlM/nAl3n458mKPcP+/ZCmG6/Ocfg26xY3PCrE/
dJWUnM364jz2GLUgCQ86IdxvuN7l3N8NqnfaYdg8hc3M7GxyINknYh1ie+wbQoZc
vliji8jwO5A7J2OGI8HGHQ/NWxJOWOnVCn1304RyyiHt7oUsxIDyPif2/TyX428=
=C+tW
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Dec_2010_11_31_38_+1100_DluGYa0p.vKCBp+O--
