Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1HOLKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:10:30 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:34108 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab1HOLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:10:28 -0400
Date: Mon, 15 Aug 2011 14:10:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: balbi@ti.com, Per Forlin <per.forlin@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v2] usb: musb: ux500: optimize DMA callback routine
Message-ID: <20110815111022.GN32750@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312801266-11888-1-git-send-email-per.forlin@stericsson.com>
 <20110812094129.GO19467@legolas.emea.dhcp.ti.com>
 <CAJ0pr18rnhN2XdP4p+o=PyKLJb6470OzsOuQpcNc29jtu1hS8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EqVOK5mkaJAMmtSx"
Content-Disposition: inline
In-Reply-To: <CAJ0pr18rnhN2XdP4p+o=PyKLJb6470OzsOuQpcNc29jtu1hS8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EqVOK5mkaJAMmtSx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Aug 14, 2011 at 07:50:46PM +0200, Per Forlin wrote:
> On 12 August 2011 11:41, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Aug 08, 2011 at 01:01:06PM +0200, Per Forlin wrote:
> >> From: Per Forlin <per.forlin@linaro.org>
> >>
> >> Skip the use of work queue and call musb_dma_completion() directly from
> >> DMA callback context.
> >>
> >> Here follows measurements on a Snowball board with ondemand governor a=
ctive.
> >>
> >> Performance using work queue:
> >> (105 MB) copied, 6.23758 s, 16.8 MB/s
> >> (105 MB) copied, 5.7151 s, 18.3 MB/s
> >> (105 MB) copied, 5.83583 s, 18.0 MB/s
> >> (105 MB) copied, 5.93611 s, 17.7 MB/s
> >>
> >> Performance without work queue
> >> (105 MB) copied, 5.62173 s, 18.7 MB/s
> >> (105 MB) copied, 5.61811 s, 18.7 MB/s
> >> (105 MB) copied, 5.57817 s, 18.8 MB/s
> >> (105 MB) copied, 5.58549 s, 18.8 MB/s
> >>
> >> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> >> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>
> >
> > this patch doesn't apply anymore:
> >
> > $ patch -p1 --dry-run < ~/apply.diff
> > patching file drivers/usb/musb/ux500_dma.c
> > Hunk #2 FAILED at 55.
> > Hunk #3 succeeded at 325 (offset -4 lines).
> > Hunk #4 succeeded at 341 (offset -4 lines).
> > Hunk #5 succeeded at 367 (offset -4 lines).
> > 1 out of 5 hunks FAILED -- saving rejects to file drivers/usb/musb/ux50=
0_dma.c.rej
> >
> > care to rebase on top of 3.1-rc1. Thanks
> >
> I can apply the patch on top of 3.1-rc1 but it has dependency to the
> patches I posted recently. This is the order the patches apply:
> 0001-usb-musb-ux500-set-dma-config-for-both-src-and-dst.patch
> 0002-usb-musb-ux500-replace-missing-DBG-with-dev_dbg.patch
> 0003-usb-musb-ux500-optimize-DMA-callback-routine.patch
>=20
> Please let me know if I should reorder the patches. I can resend all
> three in one patchset.

ok, please see if you can drop the dependency between them. $SUBJECT
isn't a fix and as such should go on next merge window.

--=20
balbi

--EqVOK5mkaJAMmtSx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSP6eAAoJEAv8Txj19kN1ypgIAKtSZddg2/rXBvb8zOY/et7F
KYSRzlviZIeLBQgE7445554rh3pZ17SWVsMGBhtzmx9vyi1TriWaaJkHUknfNiy+
hxE7804aquLl4as/q5nHh29Z84ppXcKUxiVaBwC8z8UD0Z/avQrh0lziE+sAd8I+
pDitFqgHGidyqzptmH6VWjk8cpYFAHK2J8X0Z9B72MdA22v0Ejb9pgdI3yH4gH+k
IdtNU5EPVKNQv1l6lTbEy00i9zOANey6z9Rv+FDBBoV6ZRYkKdcptVtpFP45+MrH
w/eBulxaKvtDSXNm9cb0qiVSv1e7/DLchUsoEOVVAQGR8ZJM6lEgdnRIZI1Oi1o=
=Yuoz
-----END PGP SIGNATURE-----

--EqVOK5mkaJAMmtSx--
