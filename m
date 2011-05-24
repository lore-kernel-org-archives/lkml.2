Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1EXKdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:33:33 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60669 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1EXKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:33:31 -0400
Date: Tue, 24 May 2011 13:33:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110524103325.GC14371@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BD27AEAC-1E6D-480C-9E18-A970B992AD75@ti.com>
 <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org>
 <00ed01cc19d6$e1fef520$a5fcdf60$@org>
 <20110524101817.GB14371@legolas.emea.dhcp.ti.com>
 <010501cc19fd$b8738320$295a8960$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Content-Disposition: inline
In-Reply-To: <010501cc19fd$b8738320$295a8960$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 24, 2011 at 01:31:14PM +0300, Tanya Brokhman wrote:
> > but then again, maybe you changed driver->speed
> > to super and didn't provide superspeed descriptors.
> >=20
>=20
> Yes :) The driver->speed is updated in usb_composite_probe() if
> CONFIG_USB_GADGET_SUPERSPEED is defined.
>=20
> So, are we ok with this solution? The module parameter I mean?
> Are you going to try the v13 in your branch? Please let me know how it go=
es
> and of course if you have any comments.

I think it still gives the possibility for failure. I would rather not
take that until all gadget drivers are fixed. We can help you doing that
and we only change driver->speed after all gadget drivers have their
"sensible defaults" SuperSpeed descriptors.

What do you say ? Other than that, the module parameter is, like Alan
Said, useful for debugging, so we might as well keep it.

--=20
balbi

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN24l1AAoJEAv8Txj19kN17xYH/2sfevZxOkno7F1wcYEjlEPP
x/BiOjjRdhNtKbljLXDOK5LgI9h9jp7GB1uUUNod7HgPBhIQSqgFUZWOJcRNsQXq
uBHe8eQFOHu/HvGaLcMAboBjB5MCZLSpRS8OY/jk3jJG7d14UQfFXPstxf70NRBW
mfr1oZIX2bmu38buB4Joq1n8R+omdUKOH5b8l+2+xd4l7XJiY+Uo42eoUM+SXo55
+rDxVPJLgKcOr0aJG+UUgIk/5Jirlp2Nj2LTCcWQSHSe3qXfhMsT/NvDm+dc5zBV
SfST7ZsfClCxvK3gh7GCbsoHKWa9tYSOJfYzdgawSvN/xZOWeylOG9HcovalXbw=
=6pZA
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
