Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1JNQV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:21:59 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:44691 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932444Ab1JNQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:21:57 -0400
Date: Fri, 14 Oct 2011 09:21:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v5)
Message-ID: <20111014092148.21158b85@jbarnes-desktop>
In-Reply-To: <20111006180818.GD22462@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
	<1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
	<20110930143211.5ab39c02@stein>
	<20110930153321.GA31760@hmsreliant.think-freely.org>
	<CAErSpo56QU78RHE0UOcvcT5iwcis1o_Ue=ZLPQ3GhdB483-L4Q@mail.gmail.com>
	<20110930165403.GB31760@hmsreliant.think-freely.org>
	<20111006083607.2c4eb9a5@jbarnes-desktop>
	<20111006171208.GB22462@hmsreliant.think-freely.org>
	<CAErSpo4bEcubO56hZ+PWZc0SdVEroyOmsxDtc_bBAJrxBKmAOQ@mail.gmail.com>
	<20111006180818.GD22462@hmsreliant.think-freely.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HkZaEihl677=9tdGdL5GK9D"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HkZaEihl677=9tdGdL5GK9D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Oct 2011 14:08:18 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> This patch adds a per-pci-device subdirectory in sysfs called:
> /sys/bus/pci/devices/<device>/msi_irqs
>=20
> This sub-directory exports the set of msi vectors allocated by a given
> pci device, by creating a numbered sub-directory for each vector beneath
> msi_irqs.  For each vector various attributes can be exported.  Currently=
 the
> only attribute is called mode, which tracks the operational mode of that =
vector
> (msi vs. msix)
>=20

Ok this adds new ABI in the form of sysfs files so I want to make sure
it's ok.

Matthew has dreams of a more sophisticated MSI-X management scheme, but
it sounds to me like that will mostly affect the driver interfaces and
shouldn't be incompatible with the sysfs scheme you propose here.

If so, great, we can pull this in and maybe one day someone will
implement better MSI-X support.

If not, I'd like to hear objections now; Neil has been responsive and
fixed several issues.  I don't want to block his patch unless we have
something concrete that it conflicts with.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/HkZaEihl677=9tdGdL5GK9D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOmGGcAAoJEIEoDkX4Qk9hxIEQAKShp5lhKrdco+TOo6FclpEr
l9bNgLobC61R3+OVlzkYexu9JkRrxZU+lgeyBUUme6uKlJTtQbfBXPIuCCH2fnpH
RLh8U8c8hJINndjnd57s5atqQDx5xO81UvQdPCIBQXiMk6KtiJdB9xFk9MZFOLlG
kllhHywtarEmLyQxc7I2N+oTx7+cfO6AhAlcBLpemBEogSGCNtO561bBUg1Lo2Kt
DSuIL5kqZ/yC4BrihYRW4rzjmjEDKvrf0ZoYdztA/h66as6SIg5p67XBVlNyQHMI
5jw/B29AAZyQHDLt7z01IO68l6Um+OIx8Wvdm1ie3c6WlQocCgBM09UcMbDnLXo1
yNhpZQP/ws2M8jwx/zltDwG59Wx9y/KU0/sFEUu++oXGlgGEV/DUUCoKycZ+Ep9S
NIuTihYHhT6+8tM3VWefkdMCDIrT07z1BBRiKUNUNXlFXxTlN91LGv4X9H0HG+qS
etL/He0brQVr1W4RfqvfR8EuAUL5wgkj1YV+LCwLpBLr7lYScNeo7n635ekX6gR8
EE58owvpFRdSWLrImQdvjUHvBEYe5wihRarox7ln2jjWid5ektKvLAmPr87Nh7ns
/yX+auNR0Drt9QwRSU5VvFXiSZVNibY/e9wkdbGF7IZCMyb6oCVQr5meISsSaKRm
fHC4hxPQic4LpnGjXZE2
=+MUU
-----END PGP SIGNATURE-----

--Sig_/HkZaEihl677=9tdGdL5GK9D--
