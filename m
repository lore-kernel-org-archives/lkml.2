Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2AEIOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:14:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57554 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2AEIOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:14:40 -0500
Date: Thu, 5 Jan 2012 19:14:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-Id: <20120105191434.6a21befed93e6ec39a3da62d@canb.auug.org.au>
In-Reply-To: <20120105080657.GH23916@ZenIV.linux.org.uk>
References: <20120105173521.9adbe29e16ca0e7361f79c36@canb.auug.org.au>
	<20120105080657.GH23916@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_19_14_34_+1100_b77k8O3gK_VE_R04"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_19_14_34_+1100_b77k8O3gK_VE_R04
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Thu, 5 Jan 2012 08:06:57 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Thu, Jan 05, 2012 at 05:35:21PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the vfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> >=20
> > fs/reiserfs/super.c:701:2: warning: initialization from incompatible po=
inter type [enabled by default]
> > fs/reiserfs/super.c:701:2: warning: (near initialization for 'reiserfs_=
sops.show_options') [enabled by default]
> >=20
> > Caused by commit 2ddeb2a58b11 ("vfs: switch ->show_options() to struct
> > dentry *") interacting with commit f1823b7b87d1 ("reiserfs: Properly
> > display mount options in /proc/mounts") from the ext3.  This needs some
> > merge fix ... (and will probably currently cause crashes :-()
>=20
> Grrr...  Same as changes in the first commit, done to the function introd=
uced
> by the second (i.e. replace mnt->mnt_sb with dentry->d_sb).  Incidentally,

OK, I may apply that fix tomorrow.

> what are reiserfs patches doing in ext3 tree, of all places?

Its also the quota tree?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_19_14_34_+1100_b77k8O3gK_VE_R04
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBVvqAAoJEECxmPOUX5FELqAQAI/ms8PTDtvBb5PXNns+JdcA
dsmpuoJD6QXw/4WCIyAirKbrfPVtLBWwmOZE7FqzPAiRzFqLKXHSpf5dF4F07aU6
QHEn24nAE/1m0B+m0PcRFJlou7lsCbrRFIrtaVBsSH9mCWcisaliKr+RDFkQstLv
2bAtebjtzVjKebT2NrXNomySXtESsb7YzM4Qzz4m1GurVLPUYt4tJ+MKg8kFzo9e
pPi11pLLqhn+MpW8wogMY0O+TNbzD0IFrRySDvlb49swIzgBsh0rCxFcRueAkFbK
YRitRiGRfqejdGo5V4fAvVIWWA7qp0GRVDulxZuHI8Ox+draFudXcgF87gqPbiuV
avanklG1RIjaZ+9+It0GwwqGboKPXMtAZxPvZSd6xUle1CyNtEmBi+HhYibgSt+w
T6DTOwVO8+wFUUZXe8sKtTzQ+oUE2ORcHrUsSwRurfLBHRJSVkE+ppnwqMOhc0E/
ORIHal0+0bFRKCrOCeqEaTDGpIyHAWWZ+VaxhwprwtcOGkavMseI61/cL4/WI37g
0MHCqSzKkWlF0OZQLtM6rFGRnEwi4HN3pgwHWUFjL6Prl8Q01Hj5va9BMXUj5rqR
+zW73EF46lpSeUKPM9WTcK85oyClHUmXs2EGUpGKdgf0Qv6ZPzVl0V4QpQv3qNZB
WEfFgCzVZvCtgpSeI5c/
=qRtt
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_19_14_34_+1100_b77k8O3gK_VE_R04--
