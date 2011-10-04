Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab1JDOhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:37:36 -0400
Received: from mail.gw90.de ([188.40.100.199]:50066 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab1JDOhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:37:35 -0400
Message-ID: <1317739047.4892.24.camel@mattotaupa>
Subject: Re: [PATCH v2] x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org, linux-pci@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 04 Oct 2011 16:37:27 +0200
In-Reply-To: <CAErSpo6KopVRio-84uoUf1on+VQ6zuduypztXnUwcq_8iNtbjw@mail.gmail.com>
References: <1316514056.3891.2.camel@mattotaupa>
	 <CAErSpo4FACymQXs1fuDwP87_1U2XLTxC=wKLEK2Q0scxhw7R+Q@mail.gmail.com>
	 <1317116380.4877.5.camel@mattotaupa>
	 <CAErSpo6KopVRio-84uoUf1on+VQ6zuduypztXnUwcq_8iNtbjw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lAs5GTjQJfVgpAdA5ajH"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lAs5GTjQJfVgpAdA5ajH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 27.09.2011, 08:09 -0600 schrieb Bjorn Helgaas:
> On Tue, Sep 27, 2011 at 3:39 AM, Paul Menzel wrote:
> > Am Dienstag, den 20.09.2011, 10:39 -0600 schrieb Bjorn Helgaas:
> >> On Tue, Sep 20, 2011 at 4:20 AM, Paul Menzel wrote:
> >> > ...
> >> >
> >> > Using coreboot [1] with this board the problem does not exist but th=
is quirk also does not affect it either. To be safe though the check is tig=
htened to only take effect when the BIOS from American Megatrends is used.
> >> >
> >> >        15:13 < ruik> but coreboot does not need that
> >> >        15:13 < ruik> because i have there only one root bus
> >> >        15:13 < ruik> the audio is behind a bridge
> >>
> >> I'd like to know more about this coreboot situation.  Would it be
> >> possible to get a dmesg log from the system with coreboot?  I'd like
> >> to see how coreboot configures this device differently.
> >
> > I had attached that to the Bugzilla report #30552 [2], but this is down
> > at the moment. I saw that you got the output from someone on #coreboot
> > though.
> >
> >> > CC: stable@kernel.org (=E2=89=A5 2.6.34)
> >> > CC: Bjorn Helgaas <bhelgaas@google.com>
> >> > CC: Thomas Gleixner <tglx@linutronix.de>
> >> > CC: Ingo Molnar <mingo@redhat.com>
> >> > CC: H. Peter Anvin <hpa@zytor.com>
> >> > CC: x86@kernel.org
> >> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> >> > Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
> >>
> >> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> >>
> >> This is fine with me.  I don't think it's the final solution, but I
> >> think it's worth doing for now.
> >
> > Thank you. I could not see this in Linus=E2=80=99 tree [3] yet. Jesse, =
could you
> > pick that up as you have done for the other commit? (Where is your
> > (temporary) tree located?)
>=20
> Jesse's on vacation right now.

It looks like Jesse is back from vacation. Jesse, I hope you could enjoy
it and I am sorry for bothering you right after you have been back.

Is it possible to get this patch in for Linux 3.1?

> I'm in the middle of setting up a temporary tree for the interim.


Thanks,

Paul

--=-lAs5GTjQJfVgpAdA5ajH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6LGicACgkQPX1aK2wOHVjMjgCeNjMO4yvCuSYLevqhiDFdtj4v
ikMAn0VkVtbbnsXtYRQhQvowRFmkwlsd
=oXJs
-----END PGP SIGNATURE-----

--=-lAs5GTjQJfVgpAdA5ajH--

