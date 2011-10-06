Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1JFPOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:14:41 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:57196 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758284Ab1JFPOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:14:39 -0400
Date: Thu, 6 Oct 2011 08:14:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE
Message-ID: <20111006081435.74b00765@jbarnes-desktop>
In-Reply-To: <1317739047.4892.24.camel@mattotaupa>
References: <1316514056.3891.2.camel@mattotaupa>
	<CAErSpo4FACymQXs1fuDwP87_1U2XLTxC=wKLEK2Q0scxhw7R+Q@mail.gmail.com>
	<1317116380.4877.5.camel@mattotaupa>
	<CAErSpo6KopVRio-84uoUf1on+VQ6zuduypztXnUwcq_8iNtbjw@mail.gmail.com>
	<1317739047.4892.24.camel@mattotaupa>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U_Ydo1j5h3WZaUidPkQBo1Q"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/U_Ydo1j5h3WZaUidPkQBo1Q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 16:37:27 +0200
Paul Menzel <paulepanter@users.sourceforge.net> wrote:

> Am Dienstag, den 27.09.2011, 08:09 -0600 schrieb Bjorn Helgaas:
> > On Tue, Sep 27, 2011 at 3:39 AM, Paul Menzel wrote:
> > > Am Dienstag, den 20.09.2011, 10:39 -0600 schrieb Bjorn Helgaas:
> > >> On Tue, Sep 20, 2011 at 4:20 AM, Paul Menzel wrote:
> > >> > ...
> > >> >
> > >> > Using coreboot [1] with this board the problem does not exist but =
this quirk also does not affect it either. To be safe though the check is t=
ightened to only take effect when the BIOS from American Megatrends is used.
> > >> >
> > >> >        15:13 < ruik> but coreboot does not need that
> > >> >        15:13 < ruik> because i have there only one root bus
> > >> >        15:13 < ruik> the audio is behind a bridge
> > >>
> > >> I'd like to know more about this coreboot situation.  Would it be
> > >> possible to get a dmesg log from the system with coreboot?  I'd like
> > >> to see how coreboot configures this device differently.
> > >
> > > I had attached that to the Bugzilla report #30552 [2], but this is do=
wn
> > > at the moment. I saw that you got the output from someone on #coreboot
> > > though.
> > >
> > >> > CC: stable@kernel.org (=E2=89=A5 2.6.34)
> > >> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > >> > CC: Thomas Gleixner <tglx@linutronix.de>
> > >> > CC: Ingo Molnar <mingo@redhat.com>
> > >> > CC: H. Peter Anvin <hpa@zytor.com>
> > >> > CC: x86@kernel.org
> > >> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > >> > Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
> > >>
> > >> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > >>
> > >> This is fine with me.  I don't think it's the final solution, but I
> > >> think it's worth doing for now.
> > >
> > > Thank you. I could not see this in Linus=E2=80=99 tree [3] yet. Jesse=
, could you
> > > pick that up as you have done for the other commit? (Where is your
> > > (temporary) tree located?)
> >=20
> > Jesse's on vacation right now.
>=20
> It looks like Jesse is back from vacation. Jesse, I hope you could enjoy
> it and I am sorry for bothering you right after you have been back.
>=20
> Is it possible to get this patch in for Linux 3.1?

Yeah looks safe.  You'll have to send it straight to Linus though with
my ack; my tree isn't quite back up yet (have my new key signed so
maybe tomorrow).

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/U_Ydo1j5h3WZaUidPkQBo1Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOjcXbAAoJEIEoDkX4Qk9h+ZoQAMROiVEvYsQw623iIccXa+JJ
1O55Buz+VxLME/UHlfPnGy77CFvmADuaJNVjn+OMrAg1WpsBm1Q/0GfENeZzFRzD
RUJviXXyIPe73gQ+b3woRSdhouixa2L2zSm+QPBjPQRJpiZNLMxuYQ6sS7CQwA18
JFPd5HkY0tYRYaGXYCyEc2gpzRRYNIY2KQJWD8SZtBtqVvvKIdXCemY8Au0m0j9p
9gNwHfLi4G1kWsxjY5o7bk+7ONQQY5jg2ZZEMRg6qb7eQdwUwYqWSbUGzxhoR9h7
mTovQS69uuLJrnpNZC/LA+J2f8hQlsEX4NqkLpkwMD582dsGnCvpvtPy+3I4msaE
be6eXh7wPELZXUhTYujx/lDqIvsAwP8tjprvvj0anYTtvNGrwuHVxOEA8NyY3LBH
+IVoVFzLAzShDSnTHphKP1bdHviGkjswYMMxyN/A9zGuhgptw1WyGJ7iLq3c7wx/
93mUlaK+8VZ6HYgqsEtJf7oVj7G+mWZsi8rwCVLcTC1zGUo2585Py8Nbv1ot92Zl
ABaxtJBLFBnUgTYGx+THFgNELxTeUouwaljg7n+/O3H/PD0EhqYjW33rEp9+mYgQ
+oEvlDwe35jx+ySBfvcuvnG1onW/LR/q5njiFIufjP2PUU1f2OnfTIztfpEh5ySB
vSlYLxWBqYvZfXjVYHPW
=hvK3
-----END PGP SIGNATURE-----

--Sig_/U_Ydo1j5h3WZaUidPkQBo1Q--
