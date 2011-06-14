Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1FNBUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:20:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51393 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1FNBUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:20:10 -0400
Date: Mon, 13 Jun 2011 21:20:06 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 3/7] KVM-HV: KVM Steal time implementation
Message-ID: <20110614012005.GE5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-4-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-4-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xJK8B5Wah2CMJs8h
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
> This patch contains the hypervisor part for it. I am keeping it separate =
=66rom
> the headers to facilitate backports to people who wants to backport the k=
ernel
> part but not the hypervisor, or the other way around.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9rdFAAoJEH65iIruGRnNq88H/iyk8CHuPIFW3LDZPsomMTXq
Df1iPyPdUWJ5fbe3VQ6Plg8DKEYzrOd/H4rMc5XzP6A6T/lDSmUdLBqCfmtGMF/4
8+sdZ1YSyaejYPp0j7Dklg3McoFNhVtYKTXJYj4eNuOUHv4dsGl//HFGeUVxRdym
XNDaqQg1T/mRLogkRO1NadLYr3+XGHKk7sBubrkh675+nx+cKGiVNrc67okjsojs
cP+jQ7G4Rnx9n1uWzwrbcuRVGhNepsUQuWRnW5pO0/112mRVcdkWhr2PNOOOLI0V
IVn2XUmK6tGu7+xG5XA02TjnVxh0MVULpQfY6hjXG1U0xw0Q6+QHeNxp4BTF+qU=
=RaLm
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
