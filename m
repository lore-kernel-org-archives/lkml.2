Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1GETgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:36:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39232 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1GETgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:36:20 -0400
Date: Tue, 5 Jul 2011 15:36:15 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 3/9] KVM-HDR: KVM Steal time implementation
Message-ID: <20110705193615.GC3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-4-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-4-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> To implement steal time, we need the hypervisor to pass the guest informa=
tion
> about how much time was spent running other processes outside the VM.
> This is per-vcpu, and using the kvmclock structure for that is an abuse
> we decided not to make.
>=20
> In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
> holds the memory area address containing information about steal time
>=20
> This patch contains the headers for it. I am keeping it separate to facil=
itate
> backports to people who wants to backport the kernel part but not the
> hypervisor, or the other way around.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2evAAoJEH65iIruGRnNPzMIALxeuYB2E6pXvEYVJUkyK6DA
W/TzHN/Jey6XOpnNHgLwHNhkoQw0fypE2ZPu0LwGxEw3TzooLkfNuKQKSbbNu8VE
yb9bj664y8hA2mCAU2x1SHVVvV1d/Cb+yy/tgkoRSL7QDk52nUtCuSAY5GH/FSs8
2BNt39V7j2jW8bc2BW+8dwYCuuDfAVJ0NZg1atZMqIICztXFoihr7rIAQ3cUn2/f
6Bav9KkkJJ8Fe0UU1RUJAPYpp5wdIzYzNXHE/T4RyOxGZSircPy6NlLsNQoYfxZg
pTDVclGNzw+KKPJNwzWoTcS6uUlkFDc5Z6IttubjMiNXrHc/m0gwMZre4hrbNFo=
=6Ln6
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
