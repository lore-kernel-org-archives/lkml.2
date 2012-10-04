Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2JDVKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:10:05 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:51927 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2JDVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:10:03 -0400
Date: Thu, 4 Oct 2012 22:09:59 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: i915 problems with suspend to disk
Message-ID: <20121004210959.GJ25498@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <20121004192017.GI25498@carfax.org.uk>
 <20121004193139.GJ5661@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/D3X8sky0X3AmG5"
Content-Disposition: inline
In-Reply-To: <20121004193139.GJ5661@phenom.ffwll.local>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/D3X8sky0X3AmG5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 04, 2012 at 09:31:39PM +0200, Daniel Vetter wrote:
> On Thu, Oct 04, 2012 at 08:20:17PM +0100, Hugo Mills wrote:
> >    On 3.6, I've got a problem with my video driver after resuming from
> > suspend-to-disk: the lower part of the display flickers, rapidly but
> > irregularly (think of a neon sign in a bad film noir), flicking
> > between the correct display and... something else, it's hard to see
> > what.
> > 
> >    Shutting the lid of the machine (to trigger a suspend-to-ram) and
> > waking it up again fixes the flicker.
> > 
> >    In syslogs, I have nothing obvious on suspend, and this warning on
> > resume:
[snip]
> >    Hardware is a Lenovo Thinkpad Edge13, lspci says:
> > 
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> > 
> > aka
> > 
> > 00:02.0 0300: 8086:2a42 (rev 07)
> > 
> >    Let me know if you need more information. I can probably manage a
> > bisect if necessary -- it's easily repeatable as a bug.
> 
> Before you do a bisect, can you try the drm-intel-fixes branch from
> http://cgit.freedesktop.org/~danvet/drm-intel or a bit more risky, latest
> upstream git? That contains a completely rewritten modeset code, which
> might fix this already. To fix the breakage on 3.6 I guess we need a
> bisect - at least I don't have any idea off-hand what could have gone
> wrong here.

   Thank you for the quick response.

   The drm-intel-fixes branch seems to have done the trick. No more
flickering. I think we can call this one fixed.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--W/D3X8sky0X3AmG5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUG37J79z9OVl50rAAQKq0RAAj/o9mB+mV/2MjyQe+XX/+ws1zh/G2gMM
Pth8pXZTE5tlpoL95HHcRsyOLyzN8hGCdLeTSNaGlZmbflIBBV3CXBN3XLi5ytGs
cLTLruT8Yt6/S4SdWDMxNUlVxEmu6DFILCQpiPI8ZwpIZ/LOflvlki1eiP3pB4wy
Bk1rMsCnbE9IuOb4PFFaiKEVsQ4GgZqcEfUSo+msel3+JhlKzsTU90WmRDSuAn5Z
mUB23zyWjQEDNCC2ovmtG+CZ1pOODh4Iw/Ixv4fp028p+MSbmyKLQlqmLL5o1mHZ
AelaInL5BUcAJWbCo8hnBJiYlzK9J3mH4MAeqrsKf1k8pXgjAoOb21jRwqUDGyev
Lcc253ALTqxdTd+CkRGwdZwGU7cao6Aoc7b0qGa03Ygs7G2rnGwthpYevVNfjmfL
oZbbhzVU8pkUyjcLcIg2KPAKLbheheKQ4kt6DWlpLweZnZB21yoxTI9soND3x27F
GbbDquY5LfmhdPfXS4togwH4BqQczb840277YRpi0T/AtjDOL4TlNsSzeiP/yDuF
4prlfR5IzHbar/EwLOpklchnucag4yiKkfBXNPQwV1WkV2cCUMKio8oukzldzpFP
l9xqpjz+qzjugl1dVdJVb95Erc2zEdMDVHzC6L+15ZvfgBCA52zMs3dny/6EKX5g
6owA9eCLaD0=
=OPa1
-----END PGP SIGNATURE-----

--W/D3X8sky0X3AmG5--
