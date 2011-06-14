Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1FNBVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:21:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1FNBVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:21:20 -0400
Date: Mon, 13 Jun 2011 21:21:16 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 6/7] KVM-GST: adjust scheduler cpu power
Message-ID: <20110614012116.GH5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-7-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oox5VnwalALFvA7"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-7-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oox5VnwalALFvA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jun 2011, Glauber Costa wrote:

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

--2oox5VnwalALFvA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9reMAAoJEH65iIruGRnNpK4H/2N2y0lzZGbK1lqcJ3m5UKvH
OuhwWaD8wmenPrijoIQ1jIg3p1kWdi+lqYSxPM1siLBTBYUAa05Y+SRw4qo55ZvJ
y1YkNc6BCnygiCtyhlc/kTvJz+bjMW2eM4biY2KDpNcP+aCiwxzUYqrWjBjsGcPh
x706va9EDfirNg/azXRxj+q8YauRzw+ea9VkqspQWLduDF8Mty0H6iJBzctqx69l
5NVcVDZVAztMA8BOAbcGGQ61J7OaZe9vEwLrBlgM7UrDfRxRJ1Si5Ht9fQvwZlPe
zcu38yw85656q+cFN7V/1PrmFEUBST04aT4pn+JqUHG2dLlIg7/67thOLPhWmo4=
=atqC
-----END PGP SIGNATURE-----

--2oox5VnwalALFvA7--
