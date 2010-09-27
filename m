Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab0I0LQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:16:49 -0400
Received: from wrar.name ([109.74.195.39]:54456 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0I0LQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:16:48 -0400
Date: Mon, 27 Sep 2010 17:16:31 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Swsusp patches applied to suspend-2.6#linux-next
Message-ID: <20100927111631.GA6759@wrars-comp.wrarsdomain>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
 <20100927080000.GA7032@wrars-comp.wrarsdomain>
 <4CA055EF.6050608@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <4CA055EF.6050608@tuxonice.net>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 06:29:35PM +1000, Nigel Cunningham wrote:
> >> On my laptop, single-threaded compression actually slows writing down =
=66rom
> >> 175MB/s to around 100-120MB/s (depending on how well the image compres=
ses).
> >> Reading speed improves from 218MB/s to around 245MB/s. I expect that
> >> multithreaded writing would bring the writing (and reading) speeds back
> >> up. It's on my swsusp to do list :)
> > Works here.
> What sort of speeds are you seeing?
[  343.549378] PM: Image written at 107 MB/s.
[  343.549379] PM: Image read at 205 MB/s.
Latest ToI (on .35; with the lzo compressor; no clue about
multithreadedness, though there are 4 CPUs here): I/O speed: Write 166
MB/s, Read 192 MB/s.

--=20
WBR, wRAR (ALT Linux Team)

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJMoH0PAAoJEOih81koZvPBhGEH+wav+J+hTqqeDBUJx/NQMRXJ
NH98KNmAgaLLJ1+yzeNTfnNBUp/e4z2QMSjW6y659V086S+p3iEpvzhjN0L2iYI4
tmRF851ouLeS2gaX+zytitoz3Z1lbFVC4hO7Xvc9SEXqJVV2282/lJHwfouDJZ0L
kRP5hEEjZ57BWSOlP33o5Is8Thu+YVxDT6kfRwuTLCgR7wMHaqTYDrhYs0Qn3zpI
gBJ1QjidOR91FTst/IX3Dk8nOLi+aHbmlBn0lAv0AQii7JwZmkYTxi50U8VPbvYK
7f/g6cMytHMaPSI7TYszjfJTE1ipfwGjgykO6QXgdDUEVOWKvNEN+Oep4xppdaI=
=Yt10
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
