Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2EUOsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:48:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab2EUOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:48:52 -0400
Date: Mon, 21 May 2012 15:48:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: Fix wrong kfree calls
Message-ID: <20120521144848.GC4063@opensource.wolfsonmicro.com>
References: <1337604940.11739.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <1337604940.11739.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 21, 2012 at 08:55:40PM +0800, Axel Lin wrote:
> The devm_kzalloc function eliminates the need for manual resource releasing
> and simplify error handling. Resources allocated by devm_* are freed
> automatically on driver detach.

Applied, thanks.

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPulXGAAoJEBus8iNuMP3dKrMP/iFRr5u7Vg/k3Me2TF1TcpTY
9gWu8JYOfkIOOqUC+k5LAZf+fSy5f5xZU6ec9BxOJ3YGBNIlScz/gO7sMfNr52Gj
HL2wCzNfgvc28ARTf1BRlzxNa/m+xbku6C893Umy9/8pZnVV0fOlzHxAUKOJT4qx
w6WMOVpQ61XFxL16UxSaDqCYE6KUB2Z+n+FPRf4orEOVEqgu0qHQKFr5t+KATJzM
7YApKZDIZ8KZC4oiVF0ZAvak537nGlcuob33RM8EMiZbfzc1NP93E9IMybAMiUvc
kkwdz79YIP/4xdbk3fLoEwxMPgTrXQbJhF2jFFWJR5NgIr8Ix6XEi716MDxCR0C+
wZ2SMeGZ2pNyHJ6XfRqgYwcZ3tSwZveI7SfiFt1d6eWWm5SIVPrIMLZApnjl4S7j
hufkijn2X0ush2GCbFzxMyvlKt/W3qC5ShZKgRe9tgcBOU38d78xMlS2xi+31auX
Oqr+CmRc8iZ05m7k6wT5hNZUJ85S5D3uhQOSJeMNjfOSC/03eIGAY5ObwJ1OLH6u
lkwEUNvojDVAPxSbLV0Yi8bqXTxLrV/8t222a6OKH86JVfunzYu0ms11UoHJS2mY
8GDFQtop/UJJP6gwX4/ZwU3A17jICfHwui4oezBYtyOybkXpKVCNdhmwMsvr5wyp
zkD+uvsu6QJqidfPh6WP
=haRw
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
