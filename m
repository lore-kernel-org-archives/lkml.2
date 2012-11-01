Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003Ab2KAPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:35:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761049Ab2KAPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:35:44 -0400
Date: Thu, 1 Nov 2012 16:35:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5] pwm: vt8500: Update vt8500 PWM driver support
Message-ID: <20121101153525.GA16193@avionic-0098.mockup.avionic-design.de>
References: <1351302597-4167-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <1351302597-4167-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fQ+iYrZa/ivILmF+Nm0sphrmXaWuDC+5YH3XwZo5yWZ
 9w0I9kZ+1NqgY9zhmZzcAGz05M1azCJhm58VAbL4LTqqdsAX1a
 PgxnMcU56z9a4C0A5igNQ3e/dRR7Avb2j+yac4viUZX9QPEDTF
 NQoqbwcV9sDHXye4WfK33LeEE2D/UzdEoJjTHaiDBPRVhDlKcE
 Nn5c1r8qpAkx4zNF7vkW0/qmqXhS3U5RT66cceY4QIYOXhZNlP
 OCgOO0hhcw81KTmTy8xdkcfNZ2ktqs5eR692id7MBgefFzMQrq
 3f0TDSpnRHORuvVFPEju8SyeYKGa6zl48Azhekl0OIjadnvCFy
 Wnpfaw+ZwI1GX5qOoGgCJSKjy4l0L03sVYSVxjuUZTPiL+vvwN
 OFgZE/6hI1yo5XO69Nk9vUsp/l3G5jBrp9ZkRzlubO5zUoarQa
 bpsup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2012 at 02:49:57PM +1300, Tony Prisk wrote:
> This patch updates pwm-vt8500.c to support devicetree probing and
> make use of the common clock subsystem.
>=20
> A binding document describing the PWM controller found on
> arch-vt8500 is also included.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v4:
> return err from clk_enable rather than -EBUSY
> v5:
> replace IS_ERR_OR_NULL with IS_ERR as pointed out by Chris Brand
>=20
>  .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 ++++
>  drivers/pwm/pwm-vt8500.c                           |   86 ++++++++++++++=
------
>  2 files changed, 80 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt

Applied, thanks.

Thierry

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkpa9AAoJEN0jrNd/PrOhDeAP/0NRF9bhWj0yJDRA98AA2Q+H
qGseA0eOnW6ZwyySJuq6V4gFWCxyNnKcZp2N+M9P/W86C2hdVBQVSLL33wRHrkMM
rvqnaRgWVo2mvYc7ilKToEPifCkhuvMMleACTaJjYPTjw1VHgpzXDgJsRs6eD3cH
ChOSgBASV8VhpuQW7FHd9eIPiJSKBA4N9GdtCSUE44nQ+QAOlyYUMCzCIcFy//ZI
ixmvBpE3VolFW0xcu6ENNYTom486jE4f5u15OjUiiGzlELioXgvQAWwu5tq1opuo
EPJwaKGQmTyGBR7irAjfO6TFMDxWt9OqIUklE9JtM8241Q3/n+zW4SMmTU+RwcVo
bC8kVYhXMjfhn0D25rledGhfv6I+dLxYfxN5XSf6A3Shy9OE6pEBAD8oPkIGUYdp
UnB/DRfpKMby13PtSoCi9HHi6IRDOGT5QOZq91np8BgFOVYjR9sD18x0dPNZh3Wi
ehB7kT2QfX6maRyhccIPkpSrOXeMHLIWb33EkvGrLC0Rmbee8zDUPeIuWFIrnen+
SOeFh/ARU4FvdDlR82Tv2gVuhHTRRVQn2Z1hxZRtBnBWnpvbyI8c0/MROzjQEavm
7ERw9AS0OltJx+7D2oQjjSkWGf3GxlDIu4uwTqep1yhHM5LOvNMoJVsy4clLCj0n
5uY++5+EAsJrInZRaxx6
=k4f5
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
