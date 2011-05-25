Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1EYJ1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:27:52 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57786 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab1EYJ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:27:50 -0400
Date: Wed, 25 May 2011 12:27:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <011d01cc19ff$616055c0$24210140$@org>
 <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
 <013201cc1a96$bdda7910$398f6b30$@org>
 <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
 <015801cc1abd$ca534e20$5ef9ea60$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr6OvWOSyJed8q4v"
Content-Disposition: inline
In-Reply-To: <015801cc1abd$ca534e20$5ef9ea60$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yr6OvWOSyJed8q4v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 25, 2011 at 12:26:08PM +0300, Tanya Brokhman wrote:
> > > As I mentioned, updating all of the gadget drivers will take a long
> > > time and I don't fill confident enough doing since I'm not familiar
> > > with all of them and don't have the ability to test each of them
> > > properly. I can add SS descriptors to f_mass_storage, g_zero if it
> > > helps and of course f_uasp already has them.
> > > I'm a bit confused by this actually... We've been discussing this
> > > patch series for quite a while now and I got the impression that
> > > except for some minor comments you were all for excepting this. Was I
> > > wrong or am I misunderstanding the above?
> > > In any case, I don't feel that adding SS support for the Gadget
> > > framework should be delayed until all gadget drivers add SS
> > > descriptors because this patch series will give the developers the
> > > ability to test these gadget drivers at SS. Also, several developers
> > > addressed me offline with questions on this series so I know people
> > > are using it in their work. And of course we do :)
> >=20
> > just remove the hunk which changes composite.c speed field and it
> > should all be ok :-)
> >=20
>=20
> But that's why we added the feature flag. Isn't leaving it FALSE the same=
 as
> removing the part that updates gadget speed? It is protected with #ifdef.

you mean the module parameter ? This will mean that users will have to
remember another module parameter otherwise it will not work in some
situations :-)

the module should work without that parameter :-)

--=20
balbi

--yr6OvWOSyJed8q4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3MuPAAoJEAv8Txj19kN1KW4H/30Wq9OKL6UGm3rDhlD0n64p
o5o9S7JNqEvSVdBoUnVU6YTlbajHlHdABEOXoFU4aYmJvKtqYqX42XaeBQAcDkwT
pjC3O3vQLHfIT1Yy1AH0YylsNBIkM3n/6h0ZiaLMdudneBLXkviq/LYCbkXw1E0I
ZyfaXK/NttNgfcCx6rBOdyMzBAoJmKPxF33WBq+nRYMBrVW4DYn8zN7/SrSe26Sb
poEgQoQhn5tcA8zq4rdhafHBsqhle/PXCP8MIWud7ijS589lhguFiW0OkUfe43NV
4fthnKHSwCDDmQVb41UC0xPUXup8pUhcULJleXlWE8xH377csOJVJar9yfxFfQ0=
=pjq8
-----END PGP SIGNATURE-----

--yr6OvWOSyJed8q4v--
