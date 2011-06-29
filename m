Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1F2V4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:56:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57157 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab1F2V4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:56:36 -0400
Date: Wed, 29 Jun 2011 17:56:32 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 4/9] KVM-HV: KVM Steal time implementation
Message-ID: <20110629215632.GC3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-5-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-5-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

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


--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5+QAAoJEH65iIruGRnNA5YH/0GMsB2KK8VHucsSvAqO7vId
ZmkccGKSwe273p3ooKDQGuwC0NC9NES3dnkkItPWEdDUdxU8hrDl4dTcUXeZJLGw
YPXkFEltVPT8lG68zyO4ODreIWwEuDhNpPmGO9jpt5VT67Ypo1Tn0+B9FA9AjBNH
gkTFHqrUuzli+P6EZUsnQB+eRvQcr2F3U+fp0WQvxEygGxnonRPlMIg03gIzBtL3
Vw/6QBc/JOrcDlyxy4OZGy5ToSZp65CwnCrKu3nOtxLfftg/qVSy3Fb4z5UVE7es
Gb1CR+cSZtUxPEpzyI06BrF7BKP3bsB7bLayoWThlfoiE/T+oPQ4dQG6E/GU8Bg=
=TKoS
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
