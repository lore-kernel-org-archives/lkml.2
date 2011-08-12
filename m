Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1HLJlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 05:41:36 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:40156 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab1HLJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 05:41:34 -0400
Date: Fri, 12 Aug 2011 12:41:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH v2] usb: musb: ux500: optimize DMA callback routine
Message-ID: <20110812094129.GO19467@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312801266-11888-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NT59pYSnj1ZLVgEN"
Content-Disposition: inline
In-Reply-To: <1312801266-11888-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NT59pYSnj1ZLVgEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 08, 2011 at 01:01:06PM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
> Skip the use of work queue and call musb_dma_completion() directly from
> DMA callback context.
>=20
> Here follows measurements on a Snowball board with ondemand governor acti=
ve.
>=20
> Performance using work queue:
> (105 MB) copied, 6.23758 s, 16.8 MB/s
> (105 MB) copied, 5.7151 s, 18.3 MB/s
> (105 MB) copied, 5.83583 s, 18.0 MB/s
> (105 MB) copied, 5.93611 s, 17.7 MB/s
>=20
> Performance without work queue
> (105 MB) copied, 5.62173 s, 18.7 MB/s
> (105 MB) copied, 5.61811 s, 18.7 MB/s
> (105 MB) copied, 5.57817 s, 18.8 MB/s
> (105 MB) copied, 5.58549 s, 18.8 MB/s
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>

this patch doesn't apply anymore:

$ patch -p1 --dry-run < ~/apply.diff=20
patching file drivers/usb/musb/ux500_dma.c
Hunk #2 FAILED at 55.
Hunk #3 succeeded at 325 (offset -4 lines).
Hunk #4 succeeded at 341 (offset -4 lines).
Hunk #5 succeeded at 367 (offset -4 lines).
1 out of 5 hunks FAILED -- saving rejects to file drivers/usb/musb/ux500_dm=
a.c.rej

care to rebase on top of 3.1-rc1. Thanks

--=20
balbi

--NT59pYSnj1ZLVgEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORPVJAAoJEAv8Txj19kN1HukH/1K3jK9Y8h/GgevPF3VC7KKp
+GC7xC2xPFW1gpls2jjdUQjitiha+gP6f0bjRSbdizdHjJadNLQD4EEEX16aK6nj
m2zbEnWPlIPi9VgImyy8dwk21aaTI/8ujy8jJLUDg8X9v8kYjXBR1830U8ud0j1s
jdPX4UT8KlrOF9VaklWMVAk4aF0bTPMuh8iRhfFk6T9g75Z1Ei0C1dmhGnPYfmpQ
w9hWM9petHEXKJNw5/UkiCwX4H5WtWbmUN5Wt7LbM8EcnXy8X3eX164IfAqHzXaP
MjW/yXEBY9W+ycn7d/a3lStdzBO1kG+NhNjc+f71aL/7JpkaTyyo1CZByfH3a5k=
=ozkC
-----END PGP SIGNATURE-----

--NT59pYSnj1ZLVgEN--
