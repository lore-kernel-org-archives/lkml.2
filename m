Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2FTSwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2FTSwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:52:15 -0400
Message-ID: <1340218313.14667.0.camel@atropine>
Subject: Re: [ 04/61] Revert "drm/i915/dp: Use auxch precharge value of 5
 everywhere"
From: Adam Jackson <ajax@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Wed, 20 Jun 2012 14:51:53 -0400
In-Reply-To: <20120620173021.334111012@linuxfoundation.org>
References: <20120620173021.334111012@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hc8gVOjD389RtnhY4nBh"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hc8gVOjD389RtnhY4nBh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-20 at 10:30 -0700, Greg KH wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.

Reviewed-by: Adam Jackson <ajax@redhat.com>

Though I'd be fascinated to know how and why the original
sandybridge-enable code was right despite the documentation being wrong.

- ajax

--=-hc8gVOjD389RtnhY4nBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk/iG8kACgkQW4otUKDs0NNwcQCgyGIJpEiZX1ZvD2Xb47aiBhe9
hr0An3CP3jUkoAtKgCpNyvmajGN4HHDo
=UNjJ
-----END PGP SIGNATURE-----

--=-hc8gVOjD389RtnhY4nBh--

