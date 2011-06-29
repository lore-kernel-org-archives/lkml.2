Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab1F2V46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:56:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1F2V4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:56:55 -0400
Date: Wed, 29 Jun 2011 17:56:52 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 6/9] KVM-GST: Add a pv_ops stub for steal time
Message-ID: <20110629215652.GE3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-7-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-7-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

> This patch adds a function pointer in one of the many paravirt_ops
> structs, to allow guests to register a steal time function.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>


--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5+kAAoJEH65iIruGRnN3KcH/jfgNNCj3ugoHDFYiFuBlJI9
QqbQIwE9lV4KRQ1UeRUywnMPnpk5tf3oBEPqcPZpDuMuz2E1zYF0xF9wKlAtHBQC
FJDlsrhe4oAzHDyk80woP3/6HTmPCW28XU9iWPYrkEbmFcKrYoTwLtAm3dJJGCx/
95X31K7suJjDZ8D94r8UWDyCFj2/hdtDxRfob0092uHLlqAY7WNVFW2eyFBdqTg7
WlkI7AiQEJ8jNIGXfB01zbAcE/h+A2hIQi4lODROts9+FVsuckEWIXA9Z00CKqQf
XBuOwIXdLP+HGqIvHz/uK6wJtpbJW3SvCxU7RoCzE2KAfA5Er6mcpKQKRfWHT80=
=7k3C
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
