Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1FNBTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:19:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1FNBTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:19:48 -0400
Date: Mon, 13 Jun 2011 21:19:39 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 2/7] KVM-HDR: KVM Steal time implementation
Message-ID: <20110614011939.GD5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-3-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-3-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jun 2011, Glauber Costa wrote:

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

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9rcrAAoJEH65iIruGRnN9xEIAI4Uq9pbkzjOSF4GjdQfxlrs
kOsFo2fM8jPNyTKuTtnE6kO03Uy/M4+wVm4EPx9vzfEt7zv7v5UOn0/bLSsCbP29
eWpaMZsTl6xwheIuRQDzm+IQhPNJkJEJchRsuV61bxLzndf5xS3og3qUKzvkFn5Y
gA5MHRBNnbCEKkRx2tiyjslVJ8bv9HUEYak2dWWRAdIwCkqBJU2cweBT1xsM0tAf
/dx9d3MDaPJi7mi/jrauBKEtkybFQ9eEPErFK430AiD6QOIRnBW6VGzRNdBAf9mf
DJvmxiM6+b7ZJ2KxNSzPkEIEVPJ2ukGHToQDHYKfgH0e1IiwqjlZ86VoIeatntU=
=UeXi
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
