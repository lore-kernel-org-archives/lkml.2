Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab1FQAsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:48:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38789 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab1FQAsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:48:19 -0400
Date: Thu, 16 Jun 2011 20:48:15 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 2/7] KVM-HDR: KVM Steal time implementation
Message-ID: <20110617004815.GC27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-3-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-3-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
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


--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qRPAAoJEH65iIruGRnNOw8H/05gHtR0aSRSXHRkwB7fTe0H
OGmXgXnMFqhDMLxEyJiugYriMhZRpjK47ML9DQohdD5ApYgYEtc1FiD7f6TMgSIA
8++IKynexkjsndiAQ2kUhtrzZQzcFxNDKJK9ME97nz3cNAp2EBK7J4DJtWGp89CH
2XTcEFq+szHuGNOcISwQY2Fw90zwVIvko6Vx3RD5iQaFinsPR+ArXRzgBjjZDvW2
lqKAzRURglrO5bCoYq2uSwQy7l/7diCENHYzT0dJhTU+R/t3ExCN7Xr7lYazsYtW
pXMHiTN31Ixkoo9X8zUJMILp5QdyqKCoaVHWob5TUprEU2TN27k4PDYIP9a6Q4I=
=UBuO
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
