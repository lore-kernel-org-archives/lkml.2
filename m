Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2GEJpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:45:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab2GEJpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:45:43 -0400
Date: Thu, 5 Jul 2012 10:45:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705094541.GK4111@opensource.wolfsonmicro.com>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
 <20120703123552.GC25995@sirena.org.uk>
 <4FF2EEA1.6080204@linaro.org>
 <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF2F82D.9080507@linaro.org>
 <20120703142123.GQ29030@opensource.wolfsonmicro.com>
 <4FF54406.3000307@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tez2gqrut5pn4jhH"
Content-Disposition: inline
In-Reply-To: <4FF54406.3000307@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tez2gqrut5pn4jhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 08:36:38AM +0100, Lee Jones wrote:
> On 03/07/12 15:21, Mark Brown wrote:

> >This doesn't explain any of the issues, it just says that they exist.
> >My best guess would be that at least some of the issue is due to
> >instantiating the MFD cells from the device tree but it's hard to say
> >clearly.

> I'm guessing Arnd's email answered some of the questions you had.
> Let me know of you would like me to explain it in any greater
> detail.

No, frankly.  It was just a general "why might we put things in DT"
answer which (especially given what you say below) isn't related to the
issue at all.

> By the way, this patch has nothing to do with registering these
> devices when DT is enabled. The code already does that. This is a
> bug fix, to stop multiple registration of the ab8500 when DT is
> _not_ enabled.

Really?  It seems really surprising that adding more DT support to the
MFD core would have any bearing on something like this...

--tez2gqrut5pn4jhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9WI+AAoJEBus8iNuMP3dgeYP+gJSvQ82I/KFX4NPcox9sdhL
tihOkE/Hl60vlRx9m7vSV52k5HBvt5ugYuQynkDtqR0H1JQGKgZoduGhCUocKZRS
6M4gopgq64RVyhbgqZyyB99jxKE6kzZvxOBKF5fQXQijnCYCMrDpfO5zwxIZ5X/k
oiG9m738d4JtcFiCQA8DVmy+MZnv7Px3Iay9Nysx2Onrew+SWFRzG4dEB9BNj60b
T0zqWkSJWSEsdJztOHPuFpVE9ae656oAZ3HssF71oYQwo7xEIvhDYKpoGZsPbMxh
i40g9PRsHiklXlArPAA0Nva8sOC6XFUvIM8PoVFmLqeBTE3DGD3EKjYCD0yUaycH
yq6JvrqqSZwz4PEPFrgUPZJot+1r+7rMQBl+Omeh+k528d2nN+R2iqcZLL5P4PrL
xb5uMImjJXzSnF/TqZld7Hr6WLJaXWOwfoGRkYKUwbQIn4469ZLOxsOMwYLo+PDh
eXwosHcO3L+NkXtjQ6BorV1fsqz2Wa6GwSiG3gezODdW8BvTGi/7MFxqvS7UvTm1
2xvhWEZulyC8pkob70lh/zxVhRsz6+LVhnlmSb0BOMCinQbObGBOL35x31e1aGUa
ti5kTUEY/wfYXa3t0rOHrxj/S3rxmuOGY97KF9DMv6kCwpB1iQERmfuUnAMJxjJv
IkOnobKsDwFeldHg+Ag4
=4cij
-----END PGP SIGNATURE-----

--tez2gqrut5pn4jhH--
