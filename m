Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2JWR5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:57:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab2JWR5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:57:12 -0400
Date: Tue, 23 Oct 2012 20:51:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mitch Bradley <wmb@firmworks.com>
CC: <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023175123.GB32517@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
 <508664CA.7000601@ti.com>
 <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
 <20121023100333.GA24418@arwen.pp.htv.fi>
 <5086CD91.9070101@firmworks.com>
 <20121023172035.GB32167@arwen.pp.htv.fi>
 <5086D91A.5080109@firmworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <5086D91A.5080109@firmworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(please don't top-post)

On Tue, Oct 23, 2012 at 07:51:22AM -1000, Mitch Bradley wrote:
> Perhaps I misunderstood what you were suggesting.  I thought that, when
> you said "explicitly manage all their resources", you meant that the
> driver should know the platform-specific details about clocks and power
> domains.  That is one possible interpretation of the word "explicit".

we had two suggestions in the thread:

1) handle it in driver source code (explict)
2) handle at bus notifiers level (hidden)

archives would've helped you clear up that confusion ;-)

--=20
balbi

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhtkbAAoJEIaOsuA1yqREz2MP+wVOhQyD6TzW0tcGDMMS8MPH
ckHhQ8hdoyfwlMI+9z99Fc1ckwGAt6rcP8w6AQY4Pi9jNB1f9GMr8Yy2PAaS23MF
jtYTRnEUOHDfs1cehkXVts1fqc6aQnVw6quBEo0zmF9nO0dntvOSJahBoevaEgMi
S1D0PEtOeQw3FDnRSeYwizBndRtvBll24G1tZ8drI20J98pUXKl9nCeKIGkUtvl+
pkRPY0scJu+d00mVMu40vJZEDba6data70CxCnuoiySpIsb8nNDQ/2DtyoVJrCQB
kn+fcaDC06al+jP5Koa0VKBIYVKywhwpdTUiQs3N5uAx/781J5IGldV1xemZ9s2L
heQNx5HWjt3URgIf6jHyh2GBdfLmbH1LhIE+kxZNnYuc27EJqpYzS5UjnSkrUJ2Q
ghwfpdDGAVzyVys5sWv/h7xgZ2yV7VqtZqOhzd1ZM9QOjZ7JD6GXI6sPoka/zn1U
Bgci0/uaWpmXTEvc2zxBpz8vap58a15ONmSRz4QmkUYW+Pzz9+keWZ83xWBV1fMx
9Nz/Q24YETq6pybVqY98nN4Bk9xFukU04GpA8T+8wfBMNzE5q52b6uG5hmuloHNM
ov2YI9ONLetyUtFh0tpAu8Vq+eYmOX9YVtnhLoL472EVjngqRP7otvOv5hkQAlRG
QcZHo/D99ab33Es+0sFu
=Dt2e
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
