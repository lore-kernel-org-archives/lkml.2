Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab1FQAsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:48:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab1FQAsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:48:31 -0400
Date: Thu, 16 Jun 2011 20:48:27 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 3/7] KVM-HV: KVM Steal time implementation
Message-ID: <20110617004827.GD27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-4-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-4-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2011, Glauber Costa wrote:

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

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qRbAAoJEH65iIruGRnN7voH/jfNZbjZ80K6wT4QwABzG1K3
NDc8WDXyZO3o0QmimRdXxJj/srfMaEj+1dphQm1vpOFwhW+0N49HorIcRluFxN+R
fEfIXPDsL+c1oTJaaZFxtK7vP8+oBUFidIBIU+BygsNEjsrSSHaGc0ARvQAVYvjQ
uQXPQc/i96cxKhDBdDC7wXGudB0iNQhSUPMyGtIv8Wycy+d3HA7p+Ft2LDl70So4
zjvbhjZh7fmb/TquEan2iC7EOkzLmy9DEkqfTl/f26dxosiNm7nYelvqAmRHQr4y
hPJOnouX9eiU5wmSWD0FCgHd1UGyRDveAhFRtBBTkfMLkCIXJGllJTtF1eeTK6M=
=P3Zd
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
