Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1HCN5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:57:02 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42740 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709Ab1HCN4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:56:55 -0400
Date: Wed, 3 Aug 2011 16:56:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: balbi@ti.com, Per Forlin <per.forlin@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        users@igloocommunity.org
Subject: Re: [PATCH] usb: musb: ux500: set dma config for both src and dst
Message-ID: <20110803135650.GQ11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
 <20110803133138.GO11080@legolas.emea.dhcp.ti.com>
 <CAJ0pr183rzgoaVStgb=8Umxy3tKheTVE4vJia4qjCdwTjKmA-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5xr6Gr0irOxp3+3c"
Content-Disposition: inline
In-Reply-To: <CAJ0pr183rzgoaVStgb=8Umxy3tKheTVE4vJia4qjCdwTjKmA-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5xr6Gr0irOxp3+3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2011 at 03:53:10PM +0200, Per Forlin wrote:
> On 3 August 2011 15:31, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Aug 02, 2011 at 05:33:39PM +0200, Per Forlin wrote:
> >> From: Per Forlin <per.forlin@linaro.org>
> >>
> >> The dma driver requires both src and dst to be set.
> >> This fix is needed in order to run gadget mass storage.
> >> Patch is verified on snowball.
> >>
> >> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> >
> > should this go for stable too ??
> >
> Short answer no.
>=20
> Reason:
> I ran into this bug when applying upcoming dma driver patches. Adding
> this patch now will makes sure the musb driver works when the dma
> driver is updated..
> Up until now the dma driver only use the peripheral end point
> configuration and set it for both src and dst. Upcoming patches (not
> sure if they are submitted yet) will allow src and dst to be different
> therefore the client must set both.

ok, good ;-)

--=20
balbi

--5xr6Gr0irOxp3+3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOVOiAAoJEAv8Txj19kN1Tf0H/38bYsy+8r2CF5popA1aMmUh
NTew8avugBeVukdHUTqe/xmzZKOKdYC7/UgUR9USrZ+VKJpGhuQzaE1NiBLIgHwu
hSpiFizC3oL/pvBS/utMKi7R005DW4/o9jREigtClBB/CvCaEHhrZbOQHwoLfZy0
1hu4lRBaPecNBxjKj2/eliatiRzoNPEiUK3FoYWTM4fRRLKFdYPSSDpg8AuGe2vR
JuR2VWWB2iTOejSXFTDpES9eJ8Cn4xmu3gxlrYAmDKKaYXhaSXYXS64ghTY9EupL
FSigYJOUTkRLpPbPdhrF+2dzcdIs5Yb5IGl77/ANAZ46JID/dpYsxninHCe04wM=
=jsum
-----END PGP SIGNATURE-----

--5xr6Gr0irOxp3+3c--
