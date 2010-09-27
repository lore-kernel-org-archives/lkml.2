Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0I0IAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:00:16 -0400
Received: from wrar.name ([109.74.195.39]:48277 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab0I0IAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:00:14 -0400
Date: Mon, 27 Sep 2010 14:00:00 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Swsusp patches applied to suspend-2.6#linux-next
Message-ID: <20100927080000.GA7032@wrars-comp.wrarsdomain>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 03:43:35PM +1000, Nigel Cunningham wrote:
> Hi again Rafael.
>=20
> As discussed, here are the patches, modified to apply against your current
> linux-next tree. A new first patch splits compression support out into its
> own file, removing the need to have two versions of the load_image and
> save_image routines, minimising the changes to the remainder of the
> patches and making things cleaner than would otherwise be the case.
>=20
> On my laptop, single-threaded compression actually slows writing down from
> 175MB/s to around 100-120MB/s (depending on how well the image compresses=
).
> Reading speed improves from 218MB/s to around 245MB/s. I expect that
> multithreaded writing would bring the writing (and reading) speeds back
> up. It's on my swsusp to do list :)
Works here.

--=20
WBR, wRAR (ALT Linux Team)

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJMoE8AAAoJEOih81koZvPByRcH/0p+Z0mB2viGwS8KLednRRVx
t4Woi5+s3PM/i2Tc7wKVG3qEgYSxqzj7Qrm+kaYX7dq/udtv+f486/30ZKBA3IJW
L5Ibxyz3QZ0FEBzsj19xJgRkP/Q6ffR6+1ffNGo6BUMJtSeRgoiMfB595cs5fyab
BhNWG3Cn2szZvCC61lyvIEYjyxyGb/tVNg3u+GHUxoXcEgoMmupTpTJ3A1q3Vv1W
WyshvhlDgo0tq6J6OW4tQ22i/VyzF3Ox0pO5QsBfbW9hkXIIRP5o9hYLPzHTtp0Z
dJ5+3BDKwdSM8zrD4eN+yysYRBwT46/uRdDlV2YlcJHTceAEl3ghPHQU56NijbE=
=fh0k
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
