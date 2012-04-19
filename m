Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2DSMsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:48:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42077 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab2DSMsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:48:51 -0400
Date: Thu, 19 Apr 2012 13:48:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: virtual: Replace strict_strtol with kstrtol
Message-ID: <20120419124849.GG3046@opensource.wolfsonmicro.com>
References: <1334797425.2707.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Content-Disposition: inline
In-Reply-To: <1334797425.2707.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2012 at 09:03:45AM +0800, Axel Lin wrote:
> strict_strtol is deprecated and results in a checkpatch warning.
> Replace it with kstrtol.

Applied, thanks.

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkAmqAAoJEBus8iNuMP3dbHsQAIoUhmaxyxdCNbfLI258yAmv
6ixPoi1kiDF3qyHNKZO4EH6Rjq5ODU9gyXpaLEsuZIUA7owM2lUYW/mbohsywInh
fDsHqyTKQEnEPr9AJO5DAP1V9gh7i3SQzTM4lc90Vt0UOx4YpvWrGN6a5UtyWsv4
j4p2afI/4v5YInZytWdesEwWUli+fxFochyJpUIiYgkHYOuTo9FZMkTCOWOCGWc0
k9f3FrGeujUlNgu4KY8IgNhQs2QFYjR5KUarBY3+6Us4fIrF3QdlYzJC6N8/3mQX
5WS2zXqnk9e0LRl05U53LgiBek2V7QP1NByZd64yL8bPlUubsMDuXekhhLocLSB7
oMbOwlE6bJriEM6d5OwqjCjJjWsaQ1u1HLIRgOgvwTzbDQ72C8V+zn0Sk2alVh1q
X7F3/+UYudHlNpkMze0wDgwEQJSNX2U/yKOekDiBa7rEwX/9vjIKhxA+MZstmAYq
Zm8BqkIGUjaoICedKvwcozZ4F75psmAm/zsywaJYTGUv+2Fqu/QsmLgEvJEHqj59
L6rg7tmGB/8+8wnfPr8xYVl86XSP6tSt86BhmmABTw3mwEp/5yc+C7kF/FQMAxj/
tI7HVGSb1GdJksWy4yLMMnkBnheVqiU9uwXId8HycpUgdAVMEKUR5Puu1D3wIwu5
j2lXtA5ywfVrT9oiraUJ
=Ok9f
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
