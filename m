Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2FNLHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:07:10 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:59240 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479Ab2FNLHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:07:06 -0400
Date: Thu, 14 Jun 2012 14:05:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 08/17] i2c: omap: switch over to do {} while loop
Message-ID: <20120614110503.GN13602@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
 <1339669250-9183-9-git-send-email-balbi@ti.com>
 <CAMQu2gw-rX9Xq7PPU9sGB=EFd4f3xfsPPDdODRyU5Jwg20v4GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RHdRtM27np9fZUoh"
Content-Disposition: inline
In-Reply-To: <CAMQu2gw-rX9Xq7PPU9sGB=EFd4f3xfsPPDdODRyU5Jwg20v4GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RHdRtM27np9fZUoh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 14, 2012 at 04:33:39PM +0530, Shilimkar, Santosh wrote:
> On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> > this will make sure that we execute at least once.
> > No functional changes otherwise.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> Executing at least once instead of never is
> still a functional change :-)

there's a check for spurious interrupts. The idea was mainly to
initialise stat and bits correctly at the beginning of the handler.

Besides that "otherwise" is telling you that: "except this, there are no
other functional changes" ;)

--=20
balbi

--RHdRtM27np9fZUoh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2cVfAAoJEIaOsuA1yqREhYoP/i5tDdqvdroHlyRscJ/zjE49
+q314QxyuLVDgt524IO17JPoQba7D76x5a+IJWxNia1daKP7eQZvZt/tliNcQjSD
R2vYGb0GLlcXM+1JYow4ubJCfWoxYHIvf4EcVxV24CIrR3M+jFJs/IZl86zkeyr6
1s9RWtmt2+VkIs4hwLHSqi8ac5JCIcZNNc6diYqSNIzvf8P7al28Z6M11kyqaE5G
Q0+ze1yRnf14zJxuh+slH/3vjcdEMDeqKQBhd51m160heVxGPi8wnbVUXSx+H5QY
AWbKV9ZH+8y01Mj9LuJBQTCg4DctmS1z2gkKv6ymUUH3mrr2FOReebZn5vOAAy9h
qMdTcg/3HkuJzBGXBidLDfOm54kA40X20LmgIZ88bbO1ceNwqhtAHY8ItOlHLyRs
EvbMfSyOj506+6wYaLfRxXlrTLF5r8egbkENQYiTOVrGLbDJoL39vn4Ku+EhMw5O
1U/tfZcBn6eZg30hzT4Jad8gGdfRtD+cElHxn2ibbSZlbgHlTycetKYKPocvT0iO
3jQBrRAr1SzBBT0gUJXBK/UHpgUIqJlASMFplGdoJLyMiJ4yHO/+kkFUE2KDRDit
41pwzN7Hxtq7r3VUfTccVODAkbOzk4Hj1+cHZGOTqKSiWSX4pSTjg2FDJ/O4pgyZ
RzQjUuvK+GTvzraBgjcY
=JsG+
-----END PGP SIGNATURE-----

--RHdRtM27np9fZUoh--
