Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0FVLZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:25:37 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:53997 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0FVLZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:25:35 -0400
Date: Tue, 22 Jun 2010 13:25:30 +0200
From: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
Message-ID: <20100622112530.GD9779@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
	Michal Marek <mmarek@suse.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
	Greg Thelen <gthelen@google.com>
References: <4C1764CD.3080402@suse.cz>
 <1276782038-23441-1-git-send-email-mmarek@suse.cz>
 <20100622104412.GB9779@ethz.ch>
 <4C209AF3.2070305@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Content-Disposition: inline
In-Reply-To: <4C209AF3.2070305@suse.cz>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-NS-08528-gb3f2f6c x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Michal Marek [Tue, Jun 22, 2010 at 01:13:55PM +0200]:
> On 22.6.2010 12:44, Nico Schottelius wrote:
> > Michal Marek [Thu, Jun 17, 2010 at 03:40:38PM +0200]:
> > srctree=3D"$1"=20
> >=20
> > to catch spaces and co. in the path.
>=20
> That's the same, the value in variable assignment is not subject to word
> splitting.

Oh, indeed, you're right! Learned something!

> > Otherwise I just had a quick view over it, but seems to look good.
>=20
> Thanks!
>=20
> /me is now wondering if it's ok to push this for 2.6.35. At least, there
> were no bugreports from linux-next users so far.

Well, sometime you'll have to push it and I'm not sure how many
"no bugreports" you'll want to wait for :-)

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwgnaoACgkQ19zI5DGHffDwnACg8F9zl2Yx3W13wH9yXHx2wrlp
lfYAoKaInb9xq+Km52lyAXSXkJ0+OBrs
=8z3r
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
