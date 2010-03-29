Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0C2MZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:25:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34145 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab0C2MZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:25:49 -0400
Date: Mon, 29 Mar 2010 23:25:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>
Subject: Re: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329232542.8fd26997.sfr@canb.auug.org.au>
In-Reply-To: <4BB08A8E.6050101@kernel.org>
References: <20100329160250.1515a2ca.sfr@canb.auug.org.au>
	<s5hy6hb4p6u.wl%tiwai@suse.de>
	<20100329173852.3550bbea.sfr@canb.auug.org.au>
	<4BB08A8E.6050101@kernel.org>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Mar_2010_23_25_42_+1100_V9kr31hRc9OIG6Sm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Mar_2010_23_25_42_+1100_V9kr31hRc9OIG6Sm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Mon, 29 Mar 2010 20:10:06 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Yikes, sorry about many failures.  Now that I think about it, it
> probably would have been wiser to run the conversion script on top of
> linux-next so that new ones in linux-next aren't missed by default.
> I'll do that and send out respective patches to each subsystem tree.

Thanks, that would be good.

> Thank you very much for taking the trouble to fix them up.  I'll soon
> submit more comprehensive fix up patches for code in linux-next but
> not in mainline.

Again, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Mar_2010_23_25_42_+1100_V9kr31hRc9OIG6Sm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuwnEYACgkQjjKRsyhoI8wK6gCgg7CITbfZI76DSK6WoWJwCfYr
VE0An1qVZmpnrcmC7FMRQJeFGoebDo/T
=PBuX
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Mar_2010_23_25_42_+1100_V9kr31hRc9OIG6Sm--
