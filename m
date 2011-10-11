Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1JKFmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 01:42:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1JKFmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 01:42:47 -0400
Date: Tue, 11 Oct 2011 16:42:27 +1100
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md tree
Message-ID: <20111011164227.391cf3fd@notabene.brown>
In-Reply-To: <20111011162948.c3ca0fc8726a7d7b80e39744@canb.auug.org.au>
References: <20111011162948.c3ca0fc8726a7d7b80e39744@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q5RgDo59LqqxCOJfrzau8FO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Q5RgDo59LqqxCOJfrzau8FO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011 16:29:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the md tree, today's linux-next build (x86_64_allmodconfig)
> failed like this:
>=20
> drivers/md/dm-raid.c:597:25: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c:614:24: error: unknown type name 'mddev_t'
> drivers/md/dm-raid.c:614:40: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c:654:23: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c:654:41: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c:692:34: error: unknown type name 'mddev_t'
> drivers/md/dm-raid.c:692:50: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c:812:27: error: unknown type name 'mddev_t'
> drivers/md/dm-raid.c:812:43: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c: In function 'analyse_superblocks':
> drivers/md/dm-raid.c:852:2: error: unknown type name 'mdk_rdev_t'
> drivers/md/dm-raid.c:853:2: error: unknown type name 'mddev_t'
> drivers/md/dm-raid.c:853:19: warning: initialization from incompatible po=
inter type [enabled by default]
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'disks' in somethin=
g not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: warning: left-hand operand of comma expressio=
n has no effect [-Wunused-value]
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'disks' in somethin=
g not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:857:12: error: request for member 'meta_bdev' in som=
ething not a structure or union
> drivers/md/dm-raid.c:860:3: error: implicit declaration of function 'supe=
r_load' [-Werror=3Dimplicit-function-declaration]
> drivers/md/dm-raid.c:882:2: error: implicit declaration of function 'supe=
r_validate' [-Werror=3Dimplicit-function-declaration]
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'disks' in somethin=
g not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: warning: left-hand operand of comma expressio=
n has no effect [-Wunused-value]
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'disks' in somethin=
g not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somet=
hing not a structure or union
> drivers/md/dm-raid.c: In function 'raid_ctr':
> drivers/md/dm-raid.c:965:22: error: 'super_sync' undeclared (first use in=
 this function)
> drivers/md/dm-raid.c:965:22: note: each undeclared identifier is reported=
 only once for each function it appears in
> drivers/md/dm-raid.c: In function 'raid_status':
> drivers/md/dm-raid.c:1100:4: error: unknown type name 'raid5_conf_t'
> drivers/md/dm-raid.c:1103:4: error: request for member 'max_nr_stripes' i=
n something not a structure or union
> drivers/md/dm-raid.c: In function 'raid_io_hints':
> drivers/md/dm-raid.c:1149:2: error: unknown type name 'raid5_conf_t'
> drivers/md/dm-raid.c:1152:46: error: request for member 'raid_disks' in s=
omething not a structure or union
> drivers/md/dm-raid.c:1152:65: error: request for member 'max_degraded' in=
 something not a structure or union
>=20
> Caused by commits 4251a3bcf0e1 ("md: removing typedefs:  mdk_rdev_t ->
> struct md_rdev") and 724d5bc7708a ("md: remove typedefs: mddev_t ->
> struct mddev").
>=20
> Have you dropped better versions of these commits?  Please build test.

I'll add dm-raid back in to my build testing - I don't know why it dropped
out.

This will be fixed for tomorrow.
I might add the merge with the block layer too.

Thanks,
NeilBrown


>=20
> I have used the version of the tree from next-20111006 since
> next-20111007 had another build problem.


--Sig_/Q5RgDo59LqqxCOJfrzau8FO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpPXSznsnt1WYoG5AQJCTRAAq83rt/Uu3Yf9DQYf7xZ4nMZaU6AasqMe
rOnKN07sz7WmIkZtDyGn3Lx08kfwknRuZn7d6VTxuaef7bCjzHAEdlvDlHyIRXlm
f7/yWQNKz3g7p7jPGsZP6sDkX5EcXI8p6YafK4/0qYYXLLWI4xBbZWSg1S3O8+Io
DEHIiHf7jCLxxV6ZtFdq92z33FGTKlJ44KM+LgzywybJfQ38AQmf+cAQ+dZqqKBT
xZdCDbzVAuG6s2OQeuMZyGkVoqz6/83JD/25nfFNfy10TEMT7WrBWRsPeWU8CZqo
WjcZZeU1QnAXdAfqmjITSFCJDK+Xupk4OY03Nat8G3/xYd9anQEj6PUFJWgndxaa
HMnyan3p0ZscGLnmtBwO6gTVweu4qRPAKXMRk4SqKvWoGdlHNCWPdKs59O3j3ylQ
Z4dvC+DZGPMIAAMjjEqXXOmOIFgxbLrLKBO7lgAM4Zg54hiXPzMKKNgt0KFSDCSx
eOBzKW/db7Trjm2ecxWg6EbCq0WCv343fal6KKDlY0/ME/yExo3KCIlj30jb9bnH
tvRRZfXKPHUj6J/usQqpby2RaEGbcmlx5uKqiUzZdH0gMStq5HKaphj9JJDCGt08
gNjRtUDCgyvSgWZHXSGXWgPZJYPTIi71c6kX0WssPsGkhRLmq2KNFmQapkW6mue9
iRgkgZJYc/k=
=G5vv
-----END PGP SIGNATURE-----

--Sig_/Q5RgDo59LqqxCOJfrzau8FO--
