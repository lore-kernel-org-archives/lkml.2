Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1JKNVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:21:32 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:48224 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754245Ab1JKNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:21:30 -0400
Date: Tue, 11 Oct 2011 09:21:29 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix include dependency for mmu_notifier
Message-ID: <20111011132129.GA8151@mgebm.net>
References: <1318261575-24256-1-git-send-email-emunson@mgebm.net>
 <4E9409D3.5090507@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <4E9409D3.5090507@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011, Avi Kivity wrote:

> On 10/10/2011 05:46 PM, Eric B Munson wrote:
> >The kvm_host struct can include an mmu_notifier struct but mmu_notifier.=
h is
> >not included directly.
>=20
> Thanks, applied.  Is there a .config which causes this?
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

Not exactly, I stumbled on it while working on a set that isn't quite ready=
 to
be posted.

Eric

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlELZAAoJEKhG9nGc1bpJeEEP/2jRZ0vKbwIOn3/TtPq+g00D
UPvGR3mW7cWXlFdqPEQwKReXTypHaAUb/xtMp+WVONZoaxTE06s1iNknkXtnQ3Za
w+xr8CkLtlCAAjGyScvmOvc3OCjnLvMhY1fqrA8h/b6zDmaAwE3I7eDhSDvi8dkZ
7kCz/NW8Cl/XudfDFW8IDrE5L/NGPNGo12eVQZj9y6SUpzw7c0KdQdbYGRz6rSEm
Z3H/toAaYovIJJIXx8kBxY7rNCS+caX/C1X+NLomJu216of2DFOqAjTaa3F7YVsg
lra0tfChgDM6mx4CxQ7XoywLIFtMvBEO7vaXmar+Ba3WGiZupCH3BBt4AtoATX6I
XiSPZFV58nXDmSJhJLLsp7Cm/kDuqFH+nKaP1UPOKfb/7frrA3ywFWLQ85uYW++m
qTe3NdWj4vqQm91SsSMEfDvNGj0P9j/YGuURWWbhEbCprWx0hcqR4RSjaA3Uv3de
/VDjVtDmpMQAwTmRHcBkDO0gofNSqf9oz6OtN1DLeXkyQNNYYhXCpiKGK5jJULyZ
iuODpXgGBQX2EjEZtgeypq+jIGHEF+OCTwjbIO+p7RkeQzzM+6L6o+spMbMJx1oC
mv9XFExtl+2L497Isr0jrCj3QiytQi60mTCeWrra7rN59n+qAgjdC6dRfnhx1vhG
oLsgqeeEiiqhohsmk5di
=PNe5
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
