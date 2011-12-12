Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1LLCGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 21:06:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60427 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1LLCGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 21:06:17 -0500
Date: Mon, 12 Dec 2011 13:06:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Jerome Glisse <jglisse@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20111212130608.9684ebb0a98ee767e4b3d040@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Dec_2011_13_06_08_+1100_hO3O5YO0.2ThBoJW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Dec_2011_13_06_08_+1100_hO3O5YO0.2ThBoJW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/nouveau/nouveau_sgdma.c between commit a10e9e1dbb39
("drm/nouveau: fix oopses caused by clear being called on unpopulated
ttms") from Linus' tree and commit 649bf3ca7734 ("drm/ttm: merge
ttm_backend and ttm_tt V5") from the drm tree.

I have no idea how to fix this up, so I just used the version from the
drm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Dec_2011_13_06_08_+1100_hO3O5YO0.2ThBoJW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5WGQAAoJEECxmPOUX5FEWH0P/j1Na4TemQcXp+GHizwk7vmp
joPIviU13MQWJUYcwfx2EUunF0uLvqlZUM3+TPhde237pVE2BxZLKx3Gg+HYGTRU
TbBauGLzyjOnuC/NSDdVQpicRKMY7y7W1/gi3/+WZQE4eTPuIE+GR5YA/gc02JMj
gmfp1Kubn+/Z7e9JoFMq+QY77QStYQtXoCcUBziJpKhunjObdB/qa82Q0HAMTi1h
vatUTB8WmWx+pmvFJ5uxAWlxHqHQbY09s7ojQoKG2Ik2AF159wGkH3fkMyiA5mC8
7gzXxA3G9BEtH7GrXOTWWTD3igGOHebiNOGREWrb9/AgkZ7q2fr+MiOqFPxweiX5
Z3haZ7oQQHLMlb/d0Of3nSseKCig+F8H8QASq+RjZ59GmjgO1a9jvKRMR0g6FLnk
TAHrbdCCpeWDcxXAHDuN2XVv2bGZUQJRiq+zM3r8tjXtp1Pob0ZHE8GPaTUj8AT7
m2ejWRsTlHmQvDcmSyUtNXSHIQKj7L7xjM3kBz3DIJLxGbdFM8lphyMLSkjukjaf
K7WEbZtH2b0OgmNDZ1U26FUMpeCiQYG5Wrb5tc9R/YUuRe25FaNWuuFEEZQJVXMa
rVVXAsWYly+/sg7aIRH3a4QkD4mNPvMr6wMWteDJ4bQXLXhl6c1kSqluRr/osHSJ
6osW2lhbOeadpGprWSEh
=3xMl
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Dec_2011_13_06_08_+1100_hO3O5YO0.2ThBoJW--
