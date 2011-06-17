Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab1FQAsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:48:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab1FQAsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:48:51 -0400
Date: Thu, 16 Jun 2011 20:48:47 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 4/7] KVM-GST: Add a pv_ops stub for steal time
Message-ID: <20110617004847.GE27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-5-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-5-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2011, Glauber Costa wrote:

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

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qRvAAoJEH65iIruGRnNJS4H/R19PS4xRZnU+ReUEhrB4VQN
PlY0WgGnYu2DkyBcPqM2+XBHi9kKFrMyXcq+Fu/SAKzvCtUEpciR44YcQM38CSiC
p9JmSBzU7qZo8/Y3oRi8Jp+XeIsj2kf2apz8VNhpm6izFzWi7KVbLkJONyLx6R0n
pPkRSFUS/lh7y5WtqtMl+KLp3TUQdzRA6eGtlvt/zeOGqHw2Uemz9qJBud5ZKrle
9rBGMqm/1FrAJs3ZwG5hCgp20FXQLfCHp31X1/KFpE6b4H7koIFBgC5t9LfxSn4j
QQ3Uo0rpch8fCXyDwZ91A2zdThQ8HZE+xITHiEj4L+9dq7tPWFdT3XERxCzeRPY=
=3nFV
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
