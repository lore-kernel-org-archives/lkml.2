Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0D0Jxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:53:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:46448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753222Ab0D0Jxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:53:40 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+0MpMZ6Xu05rihIa30rZiQh/K1yruNLdIs6aOz+8
	OxYLTwbsCSmRTh
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Mark <reodge@gmail.com>
Subject: Re: [PATCH] Staging: batman-adv: fixed comments to maintain 80 char limit
Date: Tue, 27 Apr 2010 11:53:33 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-3-amd64; KDE/4.4.2; x86_64; ; )
Cc: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <1272361449-15416-1-git-send-email-reodge@gmail.com>
In-Reply-To: <1272361449-15416-1-git-send-email-reodge@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16116297.0d4Uqbg2cc";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201004271153.34972.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16116297.0d4Uqbg2cc
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mark wrote:
> This patches types.h to make sure the comments adhere to the 80 char limit
> and make checkpatch.pl happy

Your patch doesn't apply anymore. See
1270341625-28764-1-git-send-email-luisbg@ubuntu.com and follow ups [1].

Best regards,
	Sven Eckelmann

[1] https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2010-April/002476.html

--nextPart16116297.0d4Uqbg2cc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJL1rQdAAoJEF2HCgfBJntGpVYQANlWoQmjtn2JiMiIW/7X93e/
ZSlsU/IsAockIknS2qc67Ci8IDSX++lo4Faas34QUHp9cMl9fnpuc/IyTAr6lwVE
lT1KoTJCEIJIZoX9PU5Am67jW3iJj3kW2zh91AI+Hr4UEmK5Hk4oPGGkaxPE+1tG
0wHXAK3iOFfBsfHmjh6LgeijMQcQG02q6Twdl+t0Wdsv79gvkpPa/z6pwlCRZSKX
h1mjI7JMHwwddykVVjWbZK22mk8/UhgXOQsJG4OWqs9L69TESTAr42ilHqRqhK8H
x1c2RTlRTbvqHqdcFAV1Py4c34Nd9R5zwlGNRC0TSBGnff+FcxiivLXIzGxKK4EK
X9kc5MKl05M+SEaiGGZQ8YFrhFx59x8PcDA2SpqvlDzFBHe5xu9Z+Pung6c7r4sN
bjv9KzlPMi3dQjubNwMjfAAdZKS62Xt4qB4KSm+yNaDUJYkSeeSn3V9MU1fwEe3X
9IQVe8ZmRYl+H2hr58nYxIBo50FE35blv74BBVvdeyiH6a9RQZRXYdfllocfvumW
kmg8j66vIXrxgS//Mb7WnuLTNseLyRxVlkCrFxtoXfnHLTVbPoPC882CwqSGo4f4
yZBwwYY9iByAJYUWr8BgLEeL05eMq8tzIVPOmO1rhEUVkTbQfUnBsQiUz5/wp/a0
fdXGOPkGSOKxqQnRSD1X
=e867
-----END PGP SIGNATURE-----

--nextPart16116297.0d4Uqbg2cc--
