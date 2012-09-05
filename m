Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab2IEPn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:43:26 -0400
Received: from ngcobalt07.manitu.net ([217.11.48.107]:51306 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2IEPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:43:25 -0400
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Wed, 5 Sep 2012 17:43:08 +0200
From: Roland Eggner <edvx1@systemanalysen.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120905154308.GA8457@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-efi@vger.kernel.org
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
 <20120904223957.50f6a3b9@pyramind.ukuu.org.uk>
 <20120904214015.GA31325@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20120904214015.GA31325@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-09-04 Tuesday at 22:40 +0100 Matthew Garrett wrote:
> On Tue, Sep 04, 2012 at 10:39:57PM +0100, Alan Cox wrote:
> > I think it needs to be defined in terms of what the capability is
> > supposed to guarantee. I have a feeling Matthew has a pretty clear idea
> > about that in his head so can nail it fairly precisely ?
>=20
> In the absence of this capability, all users (including root) should be=
=20
> unable to cause untrusted code to be executed in ring 0. This requires=20
> some straightforward and obvious conditions like "The user must not be=20
> able to load untrusted modules", but also conditions like "The user must=
=20
> not be able to cause devices to DMA over the kernel". "The user must not=
=20
> be able to kexec into an untrusted kernel" is at the more obvious end of=
=20
> the scale. This is obviously dependent upon there being some mechanism=20
> for ensuring that the initial kernel is trusted in the first place,=20
> which is where the firmware security comes in.

You believe in firmware security?  Not yet heard of =E2=80=9CRakshasa=E2=80=
=9D?  Reading [1] may=20
change your mind.


Want to support Erics technical arguments, given in another branche of this
thread, by some =E2=80=9Cpolitical=E2=80=9D aspects:  If I have payed for a=
 device and then would
not be allowed to use it due to some obscure =E2=80=9Csecurity=E2=80=9D fea=
ture, this could
perhaps be close to criminal.  I am not a lawyer, can only guess.  A few ye=
ars ago
a friend of mine bought an originally quite expensive, used notebook for ju=
st a
few Euro.  The seller was forced to do so, just because he added RAM and ch=
anged
HD, causing activation of an unknown hardware password.  It has been set by=
 a
retailer or the vendor, the latter being one of the largest players on the =
world
market.  Certainly I will never buy a device of this brand.  If Linux mainl=
ine
would really implement some kind of knock-out =E2=80=9Csecurity=E2=80=9D fe=
ature, and would
switch from GPL to another, for such a new policy more adequate copyright
licence:  it would be sad, but technically no problem, there are plenty of
alternatives beyond penguins, windows and gates.  Other users and contribut=
ors
might follow =E2=80=A6 not good for the future of the Linux project.  Bette=
r stick to the
GPL and policy of freedom, then 20 years of aweful success on servers and
embedded devices are more likely to continue or even to grow.


[1]
Jonathan Brossard:  =E2=80=9C=E2=80=A6 We have built a generic proof of con=
cept malware for the=20
Intel architecture,  called 'Rakshasa',  capable of infecting more than 100=
=20
different motherboards.  Targets are BIOS and firmware of PCI-devices.  =E2=
=80=A6=E2=80=9D
http://www.toucan-system.com/research/blackhat2012_brossard_hardware_backdo=
oring.pdf


--=20
Roland Eggner

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAlBHcwwACgkQdN/hKfT7G/JoMQCfU2LH3GptKg0LzZwWjS1BUTEC
IRkAnj4uFyD9sjKIOUEaAAhT0gytbErx
=brq8
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
