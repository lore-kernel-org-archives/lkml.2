Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1HQTXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:23:10 -0400
Received: from threatwall.zlynx.org ([64.81.105.251]:44008 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751534Ab1HQTXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:23:05 -0400
Subject: Re: [patch 00/36] Hexagon: Add support for Qualcomm Hexagon
 architecture
From: Zan Lynx <zlynx@acm.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Date: Wed, 17 Aug 2011 13:00:44 -0600
In-Reply-To: <20110817163457.878854582@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VFpadi6cgDfbD80bpLr5"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313607653.7431.3.camel@knife>
Mime-Version: 1.0
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20110817/1QtlME-0001cn-71-linux-kernel@vger.kernel.org:zlynx@acm.org:64.81.105.251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VFpadi6cgDfbD80bpLr5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-08-17 at 11:34 -0500, Richard Kuo wrote:
> The following patch set is intended to add support for the Qualcomm Hexag=
on
> architecture to the Linux kernel.
>=20
> The Hexagon architecture is designed to deliver performance with low powe=
r
> over a variety of applications.  It has features such as multithreading,
> privilege levels, VLIW, and instructions geared toward efficient signal
> processing.  The port of Linux for Hexagon runs under a hypervisor layer.

I am curious about the hypervisor layer.

I can guess that it's an attempt to abstract away low level hardware
changes, a sort of software version of CPU microcode.

Or maybe it's a Transmeta kind of thing with dynamic recompilation into
a quickly evolving VLIW instruction set.

But what's the real reason?
--=20
Knowledge Is Power
Power Corrupts
Study Hard
Be Evil

--=-VFpadi6cgDfbD80bpLr5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk5MD9wACgkQ1IRuMHS+h7GFJQCffkjluJPTH1n+kN16LXh0r9DR
MxUAn2Jvv/zo7tPsxd0Bn+nd6aTrxFES
=8UrT
-----END PGP SIGNATURE-----

--=-VFpadi6cgDfbD80bpLr5--

