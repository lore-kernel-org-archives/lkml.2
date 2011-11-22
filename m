Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab1KVWnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:43:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:49288 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1KVWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:43:44 -0500
Date: Wed, 23 Nov 2011 09:43:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: linux-next: inclusion request for cgroup/for-next
Message-Id: <20111123094333.550d9a0f918b8a74012ed6e8@canb.auug.org.au>
In-Reply-To: <20111122161746.GB3250@google.com>
References: <20111122161746.GB3250@google.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Nov_2011_09_43_33_+1100_b3sThrsEGNJRL358"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Nov_2011_09_43_33_+1100_b3sThrsEGNJRL358
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 22 Nov 2011 08:17:46 -0800 Tejun Heo <tj@kernel.org> wrote:
>
> Can you please include the following branch into linux-next?
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
>=20
> This is the new cgroup devel branch and will follow the usual
> for-next/fixes branch convention.

OK, I have added that tree with just you as the contact.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__23_Nov_2011_09_43_33_+1100_b3sThrsEGNJRL358
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzCWVAAoJEECxmPOUX5FEseoP/3+Q45MNxfLk7TiV8dS2ip7f
5zRzNnheGslK/PveCigAIyNnZmx9B0BkJoOJsY09+pdc26PSRY29QvCaqF76iVTh
bYOrwgny4s3M1JuEzxeH+1N4utlESPKUOnSF/ekKHz5nfleHLnDVN0e0wkWoiHg0
iY4IBT+TDNeoJxLsI5pcKQObF9LpOudrb5r587yA9ZWbj+qqbUiMZ9tD2dwJJQmH
S82oPOACdC0Jrbeyy3OVkX5+xTsdP3Q91AS+yyc0r7Rqbq+fvmfirTodg8W0WtsK
GSFxDsBEh+temEnOTLFGgBw/f9rNWrIqmc0hwYyjovBLWYxrrX8jTE0yI80+ZnPW
RWhWDi2td2C5ilX6Aew2dIudeMYj6V5ZG9FiJJl8l6RwVW61mkpsHOFoI9QwCp0I
7KhELaXNsQHm4MgFdc91qfXokr3fECls8axiGQquOQDRFNkSvdiusPlOfmfmPgTo
EvaY+NchZaWOf2TbJNn9Iw/Q/vgtAWoMkk5leGlKdY8IQb0tUYyfk5jfXy8Kwfd4
l1QFqgYw/9Z/uvS3SLfujjOpe+TZW2qBne4z/JlKOMbl+PBKpEvddAPoqZXGXWkI
uZ/pLgC1Ut4aqclX1xtBqGpcZkvCv+UAZX0+aOkNouiY5mQ6FIFLBu2hfHDjj2S7
K87npSodBBpL/hLNoG0d
=BdHQ
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Nov_2011_09_43_33_+1100_b3sThrsEGNJRL358--
