Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1F2V41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:56:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab1F2V4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:56:24 -0400
Date: Wed, 29 Jun 2011 17:56:21 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 3/9] KVM-HDR: KVM Steal time implementation
Message-ID: <20110629215621.GB3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-4-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-4-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
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


--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5+FAAoJEH65iIruGRnNHGEIAKrF5di1MSDvf6nMEaW+piCl
KQAZXSE99IB1l3fH0SXf40gS8QTd475lf7WQEy1UnWnmRoBHyB/n8UNwnJF0PLWl
niwxZr5OCbeolTgDJs60RB8w28km3kbz9aFABwMgmpXodowEkkqxG1rZGLf09r1Q
adcfQTbewPi6m4WLHYnUE87jKTROzN12k4wJRT4IgMtDfFvPK6PKHosKb4D/qWkJ
Pkf+9jW7HZJgmo7U2dYJ2YkHcz8T8uneGZ/HLdPDo6qew+w8zAAq/46JXXww24Dz
gOf48QwxKNfisBfqJECvO3d0Z+TVYraD6YiuigCl4Z28MmdnhHB5WpIn2GZukt8=
=IMYj
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
