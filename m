Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab1ANJov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:44:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41340 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab1ANJon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:44:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UgQCRFR4KLxGVGQg274QstF32SQmF12JIn8pk5q+bRvkYLaqBHsUxkj4egBIHQHkYg
         7QKIXgGDS42wb2EVlxmPGE2aE1Wzq3NTbDKBDV6iP/2zogHMrqTM+ZAQ+k15qzglJ89p
         7+0n9gIdGj5VaAYKpRgkGbrUS7hqKeS2krJps=
Date: Fri, 14 Jan 2011 11:44:34 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: ecryptfs build failure
Message-ID: <20110114094434.GD4044@swordfish>
References: <20110113211535.GB4044@swordfish>
 <20110113220554.GA8313@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <20110113220554.GA8313@boyd.l.tihix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (01/13/11 16:05), Tyler Hicks wrote:
> On Thu Jan 13, 2011 at 11:15:35PM +0200, Sergey Senozhatsky <sergey.senoz=
hatsky@gmail.com> wrote:
> > Hello,
> >=20
> > Recent kernel failed to build due to ecryptfs/main.
> > 2 of 3 errors could be fixed with the following patch. The third is:
> > we make an assignment `lower_inode =3D lower_dentry->d_inode;' in
> > ecryptfs_get_inode, yet ecryptfs_get_inode knows nothing about lower_de=
ntry.
>=20
> Thanks - This was mentioned just a little bit ago on LKML by Eric
> Dumazet ([BUG] ECRYPT_FS) and Christoph responded with a patch.=20
Fixed now. Cool.

> FWIW, it doesn't look like the patch below addresses the lower_dentry iss=
ue in
> ecryptfs_get_inode().
>=20

Oops. Sorry. Nevermind, sent you v1 instead of v2.

Thanks,
	Sergey

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk0wGwIACgkQfKHnntdSXjSaoAP/fa9JKLkusJuhMpqeGYFi66fM
4xYuQpCulO0RijmD+xWzIrD6Z5MS6pdJzQqjmON1xyXZdK/Zmdam9VqfyHxp3WUY
Nbs2iQO0tnVKIeTeDWH8szGj1C4IVjdiWCWj8tPM/q+FKIOWHPUkyf6IUke3MvOh
Qtx2SjFKuvcz5fL5884=
=WQL6
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
