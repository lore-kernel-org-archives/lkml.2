Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab2EUXQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:16:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56358 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2EUXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:16:08 -0400
Date: Tue, 22 May 2012 09:16:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch the watchdog tree
Message-Id: <20120522091603.3253aa7b0e31c208b1c41e05@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_09_16_03_+1000_lCrGScxWnvYV7aOw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_09_16_03_+1000_lCrGScxWnvYV7aOw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

When I have tried to fetch the watchdog tree (from
git://www.linux-watchdog.org/linux-watchdog-next.git) today and
yesterday, the "git fetch" get a connection, but after some time (maybe
immediately) it hangs and I eventually have to kill the "git fetch".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_09_16_03_+1000_lCrGScxWnvYV7aOw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPusyzAAoJEECxmPOUX5FEHS4QAIu+ajvsN1qkfbGwMUsj4PA4
5t+tBb8Upk0Ko2gU3r/33T3yiWHP+PVq0orQ5zpienNbU++FuB7S7sg5We2DO/ni
UAPJ0maKpR1CmsOwQ/b3mIsEF3duyk+GwFgxwRSsOJPk2cahqUU/Xnx2hz/Cijk6
YOf2Zt4EV7TBQygpaayukEYQzjh6wlqeEuwjCNzBXP4+HRO/WGp+yoi/OYRtGkeo
ADldhJli6nm3xbB8iHoj32U/3jUWX6RRXfWu7GHRAvvWx/n5BcnNJQRC32LjhnOZ
QHA7kZfNMyqZVUlPOGye94hlz8FyBk25SC2HzJ5v0KbjwYvZrA+fwd9TFpnyInYo
8bVr8jEtLG9kIAZHgvrcy1VU1HIWABMIAGd+9zyt3FEennE2OtyUDMB9HnDo0/m9
C9dN/v+voeY25jvUbL+FwUzcLdbwwEIc0QnjZFPJ5YLsgQIzob431cm1Bo/o5QJE
Ak2k02JZPWMtlG4uVfdm9AgtZmy0a0dl3ktvhHme+Vf+SML28xTikt+jsFvsKEGf
Mpvn7Urq56s/3DYYoLYnxdQvt09IE418m/+QocK5aab++gWsnyZx/nO2kewcqbKC
SXVJjpU1gULOy0DoNoxviGWvMgv9mOxCPLlt7PMPgjvMMqYR6vf/M/7nP6dL5sf0
ZH9oRU/Xt/gBlUXaCNzu
=m194
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_09_16_03_+1000_lCrGScxWnvYV7aOw--
