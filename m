Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2LIX0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:26:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47647 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab2LIX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:26:11 -0500
Message-ID: <1355095558.20838.93.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 67/89] drm/radeon: properly track the crtc not_enabled case
 evergreen_mc_stop()
From: Ben Hutchings <ben@decadent.org.uk>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Sun, 09 Dec 2012 23:25:58 +0000
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DC1AF91@sausexdag04.amd.com>
References: <20121203143146.549859007@decadent.org.uk>
	 <20121203143156.904709715@decadent.org.uk>
	 <CA+5PVA6P9EDYgt2WSXyX_fNsN26rG3a9j=7vk4b2SncwQ7am+A@mail.gmail.com>
	 <A3397C8B8B789E45844E7EC5DEAD89D02DC1AF91@sausexdag04.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AulQfRwCtD3bJixq1SIQ"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AulQfRwCtD3bJixq1SIQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-03 at 15:35 +0000, Deucher, Alexander wrote:
> > -----Original Message-----
> > From: Josh Boyer [mailto:jwboyer@gmail.com]
> > Sent: Monday, December 03, 2012 10:25 AM
> > To: Ben Hutchings; Greg KH
> > Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; akpm@linux-
> > foundation.org; alan@lxorguk.ukuu.org.uk; Deucher, Alexander
> > Subject: Re: [ 67/89] drm/radeon: properly track the crtc not_enabled c=
ase
> > evergreen_mc_stop()
> >=20
> > On Mon, Dec 3, 2012 at 9:32 AM, Ben Hutchings <ben@decadent.org.uk>
> > wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Alex Deucher <alexander.deucher@amd.com>
> > >
> > > commit 804cc4a0ad3a896ca295f771a28c6eb36ced7903 upstream.
> > >
> > > The save struct is not initialized previously so explicitly
> > > mark the crtcs as not used when they are not in use.
> > >
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >=20
> > Hm.  If this is needed in 3.2, presumably it's needed in 3.6 as well.  =
I
> > don't see it queued for 3.6.9, and the Cc: tag is there.
> >=20
> > Greg, Alex, was this just something that was missed, or am I wrong abou=
t
> > it needing to go into 3.6?
>=20
> The original patches should go into 3.6 kernels as well:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
diff;h=3D4a15903db02026728d0cf2755c6fabae16b8db6a
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
diff;h=3D62444b7462a2b98bc78d68736c03a7c4e66ba7e2
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
diff;h=3D804cc4a0ad3a896ca295f771a28c6eb36ced7903
>=20
> I've been meaning to follow up on it, but I haven't had the time.  Do
> I need to send explicit patches to stable@vger or can I just ask the
> above commits be cherrypicked to 3.6?

It depends on whether they *can* be cleanly cherry-picked.  You'll
presumably want them applied to all of 3.4, 3.5 and 3.6.

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-AulQfRwCtD3bJixq1SIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMUeBue/yOyVhhEJAQodLQ//TJsH/Rdv5sJxTo2RB9VJ27Odlj6srqN0
smOH8cIWDcBAu2OqRWGmSO3RExCN5MX9whrDKCX8i3yQB/5RuJNbrNbl9Y9eN00V
6PVYnuJU5Zv8udQ1H5zQYQkNyboUpJ3B7WI75jE96P7MiK5c85lDQBg+AtTQt3oV
RmvczFuMzWLVz3LnEgEddKwIq3tSsMbaktxD2RXABJLWObndQFOTrr/OZGww2vMy
31XujrshQs4ajEpi2rudigtNa9Hf/EAvN7PqM2FVG+9SUlI7Hp0aupis82sNCMa2
uZaG7eBy3NXgxh+xymdOtJ3ow00ZlnkYzPrBnw9MwiA1O2CfOnWO1IvqbbpdxkDW
4jnNCaN3YC1h70XKlX4CE4BZ9bw1uT9qDDn62Hz6+iknSzFg04NDMKEzhIEJ1Czq
3NMKX8mWdDFZYtkcdW9tK9/P73jcAzzCGb1EjMQzHzTPVF2aZTRd+3fm5vs8DYzr
+ovQuKlDmklhIB5CzjH5JBunWfJmv6ogNSrA2uHKLB9URprgPDgOHnWU1oLpAeWg
UNZ9yQk95zvKZ2M2dMDMN9paeLaptzulDzDLteZCPUgiIHH7sEMjelO2hU1vUC9V
58cp1Q7xCGgCEdiVSXVQpxJm5faWNEaAWFkUXDnyc6txU6PINLxRbbt0GxzZmR6t
LVAKPKZe40s=
=s6XS
-----END PGP SIGNATURE-----

--=-AulQfRwCtD3bJixq1SIQ--
