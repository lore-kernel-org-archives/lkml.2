Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3ACXYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:24:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58280 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3ACXYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:24:33 -0500
Date: Fri, 4 Jan 2013 10:24:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: pjones@redhat.com, jwboyer@redhat.com, mjg59@srcf.ucam.org,
        keescook@chromium.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: Pull "Load keys from signed PE binaries" branch into linux-next
Message-Id: <20130104102421.75ecbe238f94be3ad3880025@canb.auug.org.au>
In-Reply-To: <24937.1357218319@warthog.procyon.org.uk>
References: <24937.1357218319@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_Jan_2013_10_24_21_+1100_mLSr0XAoc5_LlX+V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jan_2013_10_24_21_+1100_mLSr0XAoc5_LlX+V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 03 Jan 2013 13:05:19 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Could you pull my branch to load module signing keys from signed PE binar=
ies
> into linux-next please?
>=20
> Thanks,
> David
> ---
>=20
> The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2=
ed:
>=20
>   Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.gi=
t devel-pekey

Added from today.  Though I note that it was all last posted at the end
of October and has been rebased onto v3.8-rc2 ...  I assume some of the
cc'd people will scream is there are problems.

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

--Signature=_Fri__4_Jan_2013_10_24_21_+1100_mLSr0XAoc5_LlX+V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5hMlAAoJEECxmPOUX5FEn14P/iGbxAfY/3dvM3PxAT9eGXyI
TW9IBkCwcUVL0IlJyjTsUOxdADF7fE1Lo23oeCXqhJ3eQ+TOcIqYcHM6vu09E280
TkoQNlmQ9k5frQ2tTnRYAq9J6/kHIEkfLoUeRDUrPjiWIxqc4d3ErsMMM89YVuGo
MXwKNQWFZEnCVIEaZk0d6uealUnfQhXteuH54sHROBH3pAvAy4UDVbhHZNbWFNd3
cGR5S1vwBhqRbwdjt/x9kADsx4GT1QCyPq5wWyFaRiqfw0KnMLTn3pSL6qGSyBXS
UN9HqYC4+Dp5r7pnDTU7O+YeahMAn6xTSRwOawY1OggyL0UQqAx/trWjzs36HMYX
Qt7kx+yTwOENDvho5bPPfsGg7X3YYR65TMrBzM+1/z2UmllIk8nPpa702OcpWaIs
k87cqbh4b+FSARLB+bWJ3DSgJ3FGTCLJLy8XJwfKCLLlLxIvWUwtojgUQuao9kBu
yumlbX3phUIUf5/fA8+EBWHY+cfee3YYF2IT+mu+WM7mtJ3QnJUpYWTZjUzdweFF
dkRFD4trNgSAXx36RyWYv9afGFMFAmnti9LluRpMr6IxBeOGucWLynmiixEJmWpT
YRqw41Nz2ip6qIDvui5urayfuoy6+EUV+YzpKrxkNNP8LHmreSu0nqMc8vfbwIfz
K9tPZ5ZS2s4vwxqrU32x
=R3Vg
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2013_10_24_21_+1100_mLSr0XAoc5_LlX+V--
