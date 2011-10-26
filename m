Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1JZUtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:49:06 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35763 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1JZUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:49:04 -0400
Date: Thu, 27 Oct 2011 07:48:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the moduleh tree with the  tree
Message-Id: <20111027074858.266a240f2392146c87f537a8@canb.auug.org.au>
In-Reply-To: <4EA86636.9010009@windriver.com>
References: <20111025194519.de13df739f60f9d961425558@canb.auug.org.au>
	<4EA86636.9010009@windriver.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Oct_2011_07_48_58_+1100_OhJ6pqYJDhLwD/To"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Oct_2011_07_48_58_+1100_OhJ6pqYJDhLwD/To
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Wed, 26 Oct 2011 15:57:42 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> I'm surprised to see this, since I'd dropped this chunk based on
> the last linux-next build you did before leaving for vacation.
> You should see this commit in the merge fix repo.
>=20
> ~$git ls-remote git://openlinux.windriver.com/people/paulg/modsplit-post-=
merge
> edaec64f302889b6f6eaf2d206782f46768d9922	HEAD
> edaec64f302889b6f6eaf2d206782f46768d9922	refs/heads/master
> ~$
>=20
> Maybe the server fell over again when you were trying to update?

Sorry, I know what happened ... I fetched the new origin/master, but did
not pull it into master (the checked out branch).  It will be better next
time.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_Oct_2011_07_48_58_+1100_OhJ6pqYJDhLwD/To
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOqHI6AAoJEECxmPOUX5FEg0IP/Ah4eEXlvsruC+I90NBK7Ybp
EbyrjtWdXZJAqhdQGmqCHdtsxPOUCmqw4k5z5e/OjfhGv3Cl2kyLK1yBbAFHqGF8
BNLU5tg+hGnxhzwNL2yBKSZuaNdTAoikSh0hA8qMCMdmAwFLOI3TI71E4Jl8veuN
FeD5wQkwQQ5WtqA32R43ye7tcy0BSRYtYaBHuUjVnuq5iJg8990ri8EQAw4td3am
dhHn5hVjMK3Nc2QGkn2fz9SGospkVvcyxiK6q6Q8a5S3Tb657R3mtj+QiLXxCvUw
yzhNKortg7d+txu2N4aN/T9ODwbp4Qjt2wuEB/joPlU6s80q9GuM0WWWvO9Fz6jF
SSx11bJL+3WA11UhwAS6HF2LEX1mrw9CR49PiZWIkzj//9vpbLfub85e0m58b7X2
Ds5KNtpmepefp+QPnd7R2wP7KEVfFCFpnf5DTGWS3oulnnIYHvKHXBB/vp2ras3D
ByQVNhjasQ+O9CVF0LkVMY/4Y/Yz8jmzXM9TmFBErlySmzCs2rZlooSYtqgCcgmr
MtVS3vhvOPLWSXseMmfhyFzBa723eazXESjkvFK7UpCyLqsytntTrp2X6YbKA+I+
V54WcFr26A7uksjKyl6Z/fFGFjpkkazm0k25TjJyJPXinIpmVb271mHSrClCNd+n
8ItdUHpTHujGotaA9Bj/
=ma3j
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Oct_2011_07_48_58_+1100_OhJ6pqYJDhLwD/To--
