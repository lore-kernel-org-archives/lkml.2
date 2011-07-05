Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1GETgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:36:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39232 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1GETgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:36:37 -0400
Date: Tue, 5 Jul 2011 15:36:33 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 4/9] KVM-HV: KVM Steal time implementation
Message-ID: <20110705193633.GD3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-5-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-5-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> To implement steal time, we need the hypervisor to pass the guest
> information about how much time was spent running other processes
> outside the VM, while the vcpu had meaningful work to do - halt
> time does not count.
>=20
> This information is acquired through the run_delay field of
> delayacct/schedstats infrastructure, that counts time spent in a
> runqueue but not running.
>=20
> Steal time is a per-cpu information, so the traditional MSR-based
> infrastructure is used. A new msr, KVM_MSR_STEAL_TIME, holds the
> memory area address containing information about steal time
>=20
> This patch contains the hypervisor part of the steal time infrasructure,
> and can be backported independently of the guest portion.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2fBAAoJEH65iIruGRnNxzQH/jGA27ADVsl2MxtzALTYIDWD
4RG4PQ+x2GAif2tZZiRaIBrIpWxmQY/adl9qbCXGrpA0Qi9ro7W3RJgTFPnQlTfA
Xa53dXqP8OXRczbw+Xl0+2fjFkoia0e2vMOgjAQ6X6wQZrk/3ICHi8He+oudARAP
boY9wPla6LwZagtx8vnLCupmEJZ12WQK8AZ0DqRK0TpZCET1V9hUyHnEcdjc+o/9
JWxrakrhmxp8eK8hx9RgK8fkMz75V7Lx/LfY07adlhvPbAzz6oOxVJkL11ZQH92I
XLPclQ6xlBYoZo4bIRO2WtlA2rtf0gYDeAnvQA+4n3Qi0EyG+HzYE3ouYnbtkuM=
=TxwK
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
