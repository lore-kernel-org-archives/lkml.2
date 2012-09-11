Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab2IKL7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:59:25 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:46814 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759048Ab2IKL7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:59:22 -0400
Date: Tue, 11 Sep 2012 14:54:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: balbi@ti.com, Kevin Hilman <khilman@deeprootsystems.com>,
        Greg KH <gregkh@linuxfoundation.org>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-serial@vger.kernel.org, Sourav Poddar <sourav.poddar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        alan@linux.intel.com
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120911115449.GH18907@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <87harahiv6.fsf@deeprootsystems.com>
 <20120907054932.GB3136@arwen.pp.htv.fi>
 <87oblhmu6g.fsf@deeprootsystems.com>
 <20120908190423.GA14771@arwen.pp.htv.fi>
 <504F20FA.7020003@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGu/vTNewDGZ7tmp"
Content-Disposition: inline
In-Reply-To: <504F20FA.7020003@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGu/vTNewDGZ7tmp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 05:01:06PM +0530, Shubhrajyoti wrote:
> On Sunday 09 September 2012 12:34 AM, Felipe Balbi wrote:
> >> In addition, IMO, if this was only tested on Panda (as suggested by
> >> > earlier cover letters), it really should not have been merged until =
it
> >> > got some broader testing.
> > Shubhro's got his Tested-by tag. I believe he tested on beagleboard and
> > omap4sdp. Shubhro, can you confirm which platforms you tested the UART
> > patches ? cheers
> Felipe I had boot tested on omap3sdp and onap4 sdp and did pm testing
> on both with omap3 hitting off.

Thanks ;-)

--=20
balbi

--MGu/vTNewDGZ7tmp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQTyaIAAoJEIaOsuA1yqRES4AP/161NxY2gSXOJW6E7HcGKu5f
rqRyuL6LEEjYhIxuSyAUn8bvTPfCmWGiswWFoOVbV4xWb1JfZCo1pKUzrqcU6jMs
EFFMPZDvmS99Eyu5V3WhMZCVvmEl+3pawTf2AmLhxqNKWKTcoHUEEY3SkuVlVWbt
ZTp/Vj54v+eDkvRu5PwmUQ22radyUK7L9wDSd3INAu6GYgWjijX/2xQRtM7tvmf5
Zc1LbxH6LW9eWy1jeOVaneNTlLXOXKCo5W0hG7FNoC+2QW4EQsOWMJ6G0Wi9RdPM
iQQUsrhMe187Ux/76wCuNK0Riv3U0ip5lrhX0H7l6vrFK7JE0srMc1oDxUPuAdhe
AtQ1j8WNvpfEJCymSmyp53Zuw90d4ZAxstOyho8X4vtpmIeEF6mHmhGf7uuT+xO+
F4uhev0qZ+GFGQ7L8ZeizFTluxSHwfPKHW+YcRDNf2aKrieXMplDnCd1am5E2tDY
M+oaE7CeCWSEjZi75tM1xN/a0lDAKIfeSgQkdXCrJa8sdCIqJZe46/LG0zBn5wwi
OV1HWrZS2zDumQdN1P0nMlIqeljnLNd21u8uYYyLrpNuGJEErLk1T2EQpU2Dpell
PC0N7oVnPKkiqxrA+CqM5GKt6EOGOu5jwdha4k3tLxv+Ev4JFw2dI/buFq8G4J/z
diHTtDQCE2GYb55xOWuJ
=joTh
-----END PGP SIGNATURE-----

--MGu/vTNewDGZ7tmp--
