Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab1F2V4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:56:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1F2V4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:56:13 -0400
Date: Wed, 29 Jun 2011 17:56:08 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 2/9] KVM-HDR Add constant to represent KVM MSRs
 enabled bit
Message-ID: <20110629215608.GA3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-3-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-3-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

> This patch is simple, put in a different commit so it can be more easily
> shared between guest and hypervisor. It just defines a named constant
> to indicate the enable bit for KVM-specific MSRs.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

My mail provider seems to have dropped patch 1 of the series so I can't rep=
ly
directly to it, please add my Tested-by there as well.

Tested-by: Eric B Munson <emunson@mgebm.net>

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC594AAoJEH65iIruGRnNPOsH/jvr6q/z02tWCnhVD9It3Pa8
6PYzW1avB4d0F+koFt0YTcaJ8preqIfVafJSdupkgirpZETtDUZmiYeJDb0YR83p
EyUDIeFET+oAF2Mk6LQekPeC6PNQuDZYRc17jrObYADWhl00bAkni1kupLuMoluh
sC6B0K0fCFfbOTldW0aCCqqyeFvneMLbLWHQtivOFUvcN8P27Q325CWxuA/aDn+Y
zhYLHq3BLhEDDjzskxVO5F9CNAIUVTfB+Bb9aHN/DFVyDSvtWkZqDdJ5uGzlBZgH
oh+YWFd+wnfwLmFWpeHEEhdpPr2iBnPQGeUXDX/6iGfdnJzxmNtERrA6003cnRk=
=Zi7p
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
