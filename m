Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2DDJpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:45:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39473 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756143Ab2DDJpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:45:31 -0400
Date: Wed, 4 Apr 2012 10:45:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: gpio-regulator: Basic devm_kzalloc()
 conversion
Message-ID: <20120404094524.GA3002@opensource.wolfsonmicro.com>
References: <1333491789-15883-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333491789-15883-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120404065015.GA24930@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20120404065015.GA24930@pengutronix.de>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 08:50:15AM +0200, Wolfram Sang wrote:
> On Tue, Apr 03, 2012 at 11:23:09PM +0100, Mark Brown wrote:
> > There's some other allocations but they're not so trivial as they use
> > kmemdup() and kstrdup().

> What do we gain then? I wonder if it is worth fixing one occasion if we can't
> fix the others (yet).

I probably wouldn't have bothered if I'd noticed the other allocations
before I wrote the code but as I'd already written the code...

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfBgpAAoJEBus8iNuMP3dGaEP+waccGpabtwV2xJbgEHVdH6P
XbMYXI7H7DoATUYl9gPwNSQcfzEwUcDJ2AVZPCK5lXTnBmJSJbY6f1AgHfiPJ2AO
4nKiTdy3B3CfQBur7F4OqecY3msRKqz6537ZZ+vIKbGbwOvm5f+rcnA62zUD6o+E
71vqcZvUsfVnPeAhUblKzRWR55wh2livzn0fY24oYGH5T5Fkb8vdiotOEsvMcHhg
r2VTn1kEbvhOQMhehBFbvwkknHXjuR0nqMxIO8i0FvNLirqESeiUIChBd/nHSYqK
POXTLbezalhajPN+5kBV0uKD1zXZoTci7VINbON5/76RttDnX0chF462aKSLXFcY
xkD3tAb6kxLVDp2qVAZ8tc1DLK8MpKTuSJPxh4Q8EngTA6TdYTW068QzV2PbyHkQ
brno1qeZ3nZ3uaQTLFEJsTw0qfA+PbMZNSNcULEKyByVj0UyOAGuHsUmTmZ8oVF1
mg1Qix8r1lmUJtXqDJnE4YR0Q4kYZ5OE9s9ORIOhjD2DFcOGdIC8zZ3D2ceHAY1/
tV+nIl5iZ0NF34kG4kb27Q6jcFQDzt/nKdMxxl2/yV6tSM9Gp/1gnylZGfS5P4EI
nm2gRIWbIpf93jI3Ns8vr/XiOmuQqiJ/nWCe8q/XWQ/ojdAXLpax5RxeWh2En7Pp
NllGEL2NB56gmLhKt4PP
=Css2
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
