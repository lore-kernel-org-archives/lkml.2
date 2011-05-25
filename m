Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1EYJVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:21:33 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:51112 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378Ab1EYJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:21:31 -0400
Date: Wed, 25 May 2011 12:21:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>, balbi@ti.com,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <011d01cc19ff$616055c0$24210140$@org>
 <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
 <013201cc1a96$bdda7910$398f6b30$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o7gdRJTuwFmWapyH"
Content-Disposition: inline
In-Reply-To: <013201cc1a96$bdda7910$398f6b30$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o7gdRJTuwFmWapyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 25, 2011 at 07:46:38AM +0300, Tanya Brokhman wrote:
> > Which leaves a question about the composite gadget framework.  Should
> > it be updated with SS support?  Probably not until the various function
> > drivers have all been updated.
>=20
> As I mentioned, updating all of the gadget drivers will take a long time =
and
> I don't fill confident enough doing since I'm not familiar with all of th=
em
> and don't have the ability to test each of them properly. I can add SS
> descriptors to f_mass_storage, g_zero if it helps and of course f_uasp
> already has them.
> I'm a bit confused by this actually... We've been discussing this patch
> series for quite a while now and I got the impression that except for some
> minor comments you were all for excepting this. Was I wrong or am I
> misunderstanding the above?
> In any case, I don't feel that adding SS support for the Gadget framework
> should be delayed until all gadget drivers add SS descriptors because this
> patch series will give the developers the ability to test these gadget
> drivers at SS. Also, several developers addressed me offline with questio=
ns
> on this series so I know people are using it in their work. And of course=
 we
> do :)

just remove the hunk which changes composite.c speed field and it should
all be ok :-)

--=20
balbi

--o7gdRJTuwFmWapyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3MoUAAoJEAv8Txj19kN1ycgH/jjw8nBM9aYE//KnNU3d48Fi
o6kRFFAvrigr9u454LlOU3NIHOf9/fk2QKQqgWtdQpAhNoza0EqMcgS+yejhKw3M
fGbnfI0pVN2exxW0cOqlNO+2VmaUCqDt6bAb/SaKF0w48DKTtHAkc4bEo/Aqlrsd
ZKKeVYbMVa/GRl17K4jmvyJiC6x/IzEW+AdxMeQlryMmZoXoez8MJD/dY2XU8JN7
9fJbKVYsB0DqKxtWH4wQ8K6z8rKHhusACVVvs+VWLAj5Pj/4odR1KGkQwbJ2gF/W
+/7HPRtncE3WoJHxfEGplYbGg12JyWBbVN10PlkTaN7spOBD4xlJXef3t4/xYZM=
=YZNu
-----END PGP SIGNATURE-----

--o7gdRJTuwFmWapyH--
