Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab1F2V5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:57:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1F2V5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:57:15 -0400
Date: Wed, 29 Jun 2011 17:57:11 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 8/9] KVM-GST: adjust scheduler cpu power
Message-ID: <20110629215711.GG3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-9-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oXNgvKVxGWJ0RPMJ"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-9-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oXNgvKVxGWJ0RPMJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

> This is a first proposal for using steal time information
> to influence the scheduler. There are a lot of optimizations
> and fine grained adjustments to be done, but it is working reasonably
> so far for me (mostly)
>=20
> With this patch (and some host pinnings to demonstrate the situation),
> two vcpus with very different steal time (Say 80 % vs 1 %) will not get
> an even distribution of processes. This is a situation that can naturally
> arise, specially in overcommited scenarios. Previosly, the guest scheduler
> would wrongly think that all cpus have the same ability to run processes,
> lowering the overall throughput.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>


--oXNgvKVxGWJ0RPMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5+3AAoJEH65iIruGRnNwVEIANdLdLczUHOtLgL74unJJYVq
w9/20hPULWRcqALuaXcRP42LLgrahLsf26dPGl+5mOapSptkTP5OwHK4YNCqB3TA
O7Bh5b1fyvyHA/fg618hH8Nd2znpptVAKr7tkiQebZjGBTIxbQkanpk0SwlBPoDV
5lAGPBNn69w0caLIUIXFwytPNj0S+jrp/+adbz4d+kcKvempwxsImumdDDHGVUH5
KRb0IISn2T6tfqDhyGTOTxQJp9s3BT+WO7mH8seOAcq7+pVHhm8kEXJrSvsuaUKI
8umsM8miJswBjUth+eRcxP0B3ZMj0lXczMq1P5NcVzsPLcAGUGKcsh3TB2CxPQs=
=rotX
-----END PGP SIGNATURE-----

--oXNgvKVxGWJ0RPMJ--
