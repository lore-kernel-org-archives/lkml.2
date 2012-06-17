Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab2FQUu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:50:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45100 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814Ab2FQUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:50:57 -0400
Date: Sun, 17 Jun 2012 21:50:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 2/2 v2] regmap: Add support for register indirect
 addressing.
Message-ID: <20120617205054.GW4267@opensource.wolfsonmicro.com>
References: <201206151049.q5FAn6bj003364@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mz5eWKkhz39mMVQV"
Content-Disposition: inline
In-Reply-To: <201206151049.q5FAn6bj003364@sw-eng-lt-dc-vm2>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mz5eWKkhz39mMVQV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 15, 2012 at 11:23:56AM +0100, Krystian Garbaciak wrote:
> Devices with register paging or indirectly accessed registers can configure
> register mapping to map those on virtual address range. During access to
> virtually mapped register range, indirect addressing is processed
> automatically, in following steps:
>   1. selector for page or indirect register is updated (when needed);
>   2. register in data window is accessed.

Applied, thanks.  I had to fix up a few conflicts but I think that's
done OK, please check though.

--mz5eWKkhz39mMVQV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3kLlAAoJEBus8iNuMP3dATQP/jim8ImHvpFePQL03uuOUOPW
vfx7JqlI+/EjOjdPVU29uXhlyTawFbHHKV1PiBnV9+wqB0Nt1HLc8TjnSZalwyjS
YDOB3ytYRFiai4wiCfChXBVpnZBvytTtDq56baSvkRX7l7f1rIjX/6cTrqoK1UfB
z8/ZGjK0AaL9BFZHpVWvUA5D6FjmWLjk2wTHeYX8tI9xmy2dz74VzDe8+JR6UcBe
A5pK5xtm7Xx8/hQtYXFKZBwU7+QuJiMNhYrzWhrioh+7rCmOwXtDn/VdMiS8fd1Q
gywJ6r04EdtVbVPZg+/qYxeXKVZNUqi2ekES+0/6+oJHFfWY/pDqPtS0HRaNmLEo
akrwbAKKI3S/iBzqf8tlU96lotU2PJVcyNjAj1AUnTHQtJkq2+yZlnIootONeq2/
RKv4Ge9bqCTZv5NLmLg1ArwGiDHqWxAch+aVIUBfkJOdAAU9tmtrZaZ+ULrA4fPv
4ysgSOtP0xq4gKFiFkb/M186VsTQdnPEDtcSefBzB6zil/wCnkJNepsrGV1vd/XQ
RqfNkTFgzLrBDj+0A18ZTZd5+1DrSz0XlQEqVZAJBKsP1D3zeZd3vpt4w6iP49vf
/edVLlp1TFYkcpo3+TS0M9eF149hxsDI+9l0/cmXBibDqdmv5PqrMnsbVr0b4D0Z
QlnT//41bwWkm2EnKJ5O
=Eeoz
-----END PGP SIGNATURE-----

--mz5eWKkhz39mMVQV--
