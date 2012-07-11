Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2GKRnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:43:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59594 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032Ab2GKRm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:42:59 -0400
Date: Wed, 11 Jul 2012 18:42:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix bug in regulator_mode_to_status() core
 function.
Message-ID: <20120711174257.GN3938@opensource.wolfsonmicro.com>
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
 <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
 <20120711132655.GG3938@opensource.wolfsonmicro.com>
 <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
 <201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLaBmHMi4cq+C/u4"
Content-Disposition: inline
In-Reply-To: <201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLaBmHMi4cq+C/u4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 04:13:00PM +0100, Krystian Garbaciak wrote:

> Would it make more sense to have some special enum value for that case, let say
> there would be REGULATOR_STATUS_UNDEFINED?

> Returning 0 is interpreted as REGULATOR_STATUS_OFF outside the function.
> But it may change, if ever the enumeration changes.

That'd be fine.

Also, please do submit separate changes separately.

--yLaBmHMi4cq+C/u4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/brsAAoJEBus8iNuMP3dr68P/R2uh2v0pKkm5OoijVYBHqur
QssNCEbOhYhD3jCO6JSTceAoDpxKXSL31rvEnWF9rXMpeHtaXjS317rDghcOKZLm
9v4owFc1gdyCdwnjr6WMkuonazgfK/jFK6JRVCYF3gRzvcCKmZ1P8Fh9yaE4hFCT
4jDBXdmOX39paEdI12Vm4LI3iNV7YsiAc1N0VeWmuh5XnF3ln0WZQmIJ+f0bzywf
LAKzDS8In04U3CnPm6BBC7kAoeWbBoiLmaZCxgJ+FiqiXxY0u2oBWbMhwUi/7mwk
T9UUc6iqpBQzMa1nfF6ENBdqXlDs66IS410b//S9TQ9S0btq0pMFNiQy6hZa7hK8
74N+ZmFx/eVpKBPgtmMNGVGXuUcedgaEFNNoIaL9MD5UPFdilSSsPPTHmF6EwAaK
JRfVvQwTXjCo6HJ298fO/1HMoGXMwQeWYAZnlCXWzEgbPz9g4HNlUec7rHaWzx4V
5DkA9wjuPah1CJrbtvY7g6R6dzU+S+KgTzKmAAq6YMtxy18YaBBQiGhin6EH5rqN
YcCZn6+PygVgJbaeFvRINsCaiAS7gwF8UkSWTbnKOVCvB3HJ5cdqEAOilR5JlUOH
NjQI935FLmy41tPBA9TDzr0QSrSzRiQvEhSAXSO+h6zCLDoYK8O3Iq98CSdqzXf7
V92nwaQ8vJ4OaMjXv5kq
=wZ8u
-----END PGP SIGNATURE-----

--yLaBmHMi4cq+C/u4--
