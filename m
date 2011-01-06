Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1AFAEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47397 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab1AFAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:53 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>, Alex Deucher <alexdeucher@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Sergej Pupykin <ml@sergej.pp.ru>, Dave Airlie <airlied@redhat.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110105235621.GA22850@suse.de>
References: <20110105230323.978508482@clark.site>
	 <1294271346.3044.2.camel@localhost>  <20110105235621.GA22850@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fWln6DGqOR8odELW9yft"
Date: Thu, 06 Jan 2011 00:04:44 +0000
Message-ID: <1294272284.3044.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [06/49] drm/kms: remove spaces from connector
 names (v2)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fWln6DGqOR8odELW9yft
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-01-05 at 15:56 -0800, Greg KH wrote:
> On Wed, Jan 05, 2011 at 11:49:05PM +0000, Ben Hutchings wrote:
> > On Wed, 2011-01-05 at 15:00 -0800, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please l=
et us know.
> > >=20
> > > ------------------
> > >=20
> > > From: Alex Deucher <alexdeucher@gmail.com>
> > >=20
> > > commit e76116ca9671e2e5239054a40303b94feab585ad upstream.
> > >=20
> > > Grub doesn't parse spaces in parameters correctly, so
> > > this makes it impossible to force video=3D parameters
> > > for kms on the grub kernel command line.
> > >=20
> > > v2: shorten the names to make them easier to type.
> > [...]
> > > --- a/drivers/gpu/drm/drm_crtc.c
> > > +++ b/drivers/gpu/drm/drm_crtc.c
> > > @@ -144,10 +144,10 @@ static struct drm_conn_prop_enum_list dr
> > >  	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
> > >  	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
> > >  	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
> > > -	{ DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
> > > -	{ DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
> > > -	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
> > > -	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
> > > +	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
> > > +	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
> > [...]
> >=20
> > Why change 'DisplayPort', which doesn't have a space in it?  This might
> > break a previously working kernel command line.
>=20
> That's what happened in Linus's tree, I just mirror it :)

Yeah, sorry, that was really directed at Alex.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-fWln6DGqOR8odELW9yft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATSUHFee/yOyVhhEJAQIXaA//UIyMPRN1IU2KO2KgFQKfom7pRJIYUzJz
LxMFApAMoLSGPGqj2HUx1L3WWiDmTihf/htDesv1Q4Ixn23rkSl+ys66UBzdPd1a
mqhgN+HBqgcckU1UNk3QEFioydnLBNMViPmrdSCJHR0A6SsS/2EkLRfmj9D/kmJE
0GfCO3q1hUu14YeKvx6oadzCWRjF+xIATLyXgLXci1gg6KVZguwnOHrZnMbV5383
Oyli6KHn2OPp0k8dd+OcWOjel6u2rmO9EWdsL3vhi+hiHx9hmGZkl4/jx356bL7H
2jwumy2BtZen4aOBoTV8MzHmY3qia8IKJPpsNPMcw+pWUQ/Su8XzLTNDTbkMu5G+
3j6alt2+bjZL6I3gWKOdUpOyXEqLVrqjeq8nUr6Cc4YpZ9ZEot7CznwTiyqnvBSg
3fgO2ysSBXC3JP34BTRB30DioVV/zg7tSGZgUMofXs9irOZ+keHcl9s187794lqs
dBUFn/g7wogYkA28gQYxTxaBLhbGXcx7qA47BT9AWOfes7LGn+zK7ru7i8q1yIQ6
9iVvVRnyID3nSDkTvBklq043pw3JvWytxdYkE5ZcjqZfR7WeSlQdEGHCGxmcOFx8
5j3/G+NQxA79l7DeOyetLkzu2QXjqNymZn7NkTsIZUwRpH57UUzFwqjo1roJJKVV
SCvCWJGtcKY=
=oZ9y
-----END PGP SIGNATURE-----

--=-fWln6DGqOR8odELW9yft--
