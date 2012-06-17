Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2FQUol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:44:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47639 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273Ab2FQUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:44:40 -0400
Date: Sun, 17 Jun 2012 21:44:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 1/2 v2] regmap: Move lock out from internal function
 _regmap_update_bits().
Message-ID: <20120617204436.GV4267@opensource.wolfsonmicro.com>
References: <201206151046.q5FAke4x002812@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="22hJjvOmZW2O/jbw"
Content-Disposition: inline
In-Reply-To: <201206151046.q5FAke4x002812@sw-eng-lt-dc-vm2>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--22hJjvOmZW2O/jbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 15, 2012 at 11:23:56AM +0100, Krystian Garbaciak wrote:
> Locks are moved to regmap_update_bits(), which allows to reenter internal
> function _regmap_update_bits() from inside of regmap read/write routines.

Applied, thanks.

--22hJjvOmZW2O/jbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3kGgAAoJEBus8iNuMP3dKXgP/j2GhWkbwVZvUA7Lw+fm8bq9
GJv9GgHHNhj3ZkxQc7UVI3FlxBrxfQssUP8gwuwlf7a7IqAeWGO8lyUb3wPK+t9U
VuJZa702H7DCDMNkeSA9QHLlQ7ajnsZ1sjya6NF6m2nY7GaLZC50ydm+Tu/oAxPK
1zhF0WKsvoCiuDJh2l1cE8l4y2l7X8Zj3MWuP9zAdPqehyEpWQc7XyNdHLEYThwr
0qKifBYirqSgFE6iA94YGMaDMP9LtQ90gF6dBNsE+0FPYU40x/rJqeVvc/4UOU/Q
fmBHrf3EoQUJ+O7eTDMbbV96KM4H4KDZxQXKW5b5D21L+moWGuXNRZf8aVrd5EqZ
sIK1wxcwptpaSETSWxK4LXgWoyE6YKPHgiyGOWZ0qWj0XbdH81DeHmBssnIxGs+P
JFS5B5M/E8w0gdUdvJGR/pR1bMszOdnynzjtk6sM6FqoD6Ehx2qXGkwOLz+XP2Vv
wqeuKi2qMhV06h9evZlyz4ff0nKe9rngis3oxnHljQTEJmiGTk+CiTiwnmhKdQIp
EWgLblaQEPKZirl5nWLv6OIIE2tyyunSRNO1SMGdxemBWTKA53JNOHe1svolEshm
6ADba5oRysA4yFUw0OyjojK8KC+RHrCo5V5FWSApCcKMJ7cwOX23Km/4LSLHgGqA
Y5H4l7SQ/6edO5WTbWxJ
=KorN
-----END PGP SIGNATURE-----

--22hJjvOmZW2O/jbw--
