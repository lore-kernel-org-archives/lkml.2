Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1KAQ6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:58:40 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:45989 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753650Ab1KAQ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:58:38 -0400
Date: Tue, 1 Nov 2011 09:58:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v5)
Message-ID: <20111101095833.3dddb3b8@jbarnes-desktop>
In-Reply-To: <20111101164726.GA14141@hmsreliant.think-freely.org>
References: <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
	<20110930143211.5ab39c02@stein>
	<20110930153321.GA31760@hmsreliant.think-freely.org>
	<CAErSpo56QU78RHE0UOcvcT5iwcis1o_Ue=ZLPQ3GhdB483-L4Q@mail.gmail.com>
	<20110930165403.GB31760@hmsreliant.think-freely.org>
	<20111006083607.2c4eb9a5@jbarnes-desktop>
	<20111006171208.GB22462@hmsreliant.think-freely.org>
	<CAErSpo4bEcubO56hZ+PWZc0SdVEroyOmsxDtc_bBAJrxBKmAOQ@mail.gmail.com>
	<20111006180818.GD22462@hmsreliant.think-freely.org>
	<20111014092148.21158b85@jbarnes-desktop>
	<20111101164726.GA14141@hmsreliant.think-freely.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HYH+_EOgab7OieVvIn1PjzG"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HYH+_EOgab7OieVvIn1PjzG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Nov 2011 12:47:26 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Fri, Oct 14, 2011 at 09:21:48AM -0700, Jesse Barnes wrote:
> > On Thu, 6 Oct 2011 14:08:18 -0400
> > Neil Horman <nhorman@tuxdriver.com> wrote:
> >=20
> > > This patch adds a per-pci-device subdirectory in sysfs called:
> > > /sys/bus/pci/devices/<device>/msi_irqs
> > >=20
> > > This sub-directory exports the set of msi vectors allocated by a given
> > > pci device, by creating a numbered sub-directory for each vector bene=
ath
> > > msi_irqs.  For each vector various attributes can be exported.  Curre=
ntly the
> > > only attribute is called mode, which tracks the operational mode of t=
hat vector
> > > (msi vs. msix)
> > >=20
> >=20
> > Ok this adds new ABI in the form of sysfs files so I want to make sure
> > it's ok.
> >=20
> > Matthew has dreams of a more sophisticated MSI-X management scheme, but
> > it sounds to me like that will mostly affect the driver interfaces and
> > shouldn't be incompatible with the sysfs scheme you propose here.
> >=20
> > If so, great, we can pull this in and maybe one day someone will
> > implement better MSI-X support.
> >=20
> > If not, I'd like to hear objections now; Neil has been responsive and
> > fixed several issues.  I don't want to block his patch unless we have
> > something concrete that it conflicts with.
> >=20
> > Thanks,
> > --=20
> > Jesse Barnes, Intel Open Source Technology Center
> Ping Jesse, has something gone awry here? I've not seen this show up in y=
our
> tree yet.

It's sitting in my queue and I've timed out waiting for objections.  So
I'll put it in my -next tree shortly.  Thanks for your patience Neil.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/HYH+_EOgab7OieVvIn1PjzG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsCU6AAoJEIEoDkX4Qk9hU/8P/2UXi+wnt8kY5ZZSnBg6VzkJ
OLC9U/AphTYakICtWxmvrUl9NpkxPCNHLRYpO7mmby6f/pHwxgwLoTEdaMe9vepJ
VUfCq44Ry8hpRAP8tnSBmxnpiQsFWFnTxbXIOFj3ZrJq/YiQLU3DdIhrfmz00nb8
NT0Fh3Dm7OhTOkJ/EtLATV0z6crW393Soy8a65YyMrcInAgGEb3MuUpGgPWyK3NE
xEiu50EwcgHTgoA9Wp5PEfnv5TYt3+f+Xp2lbsC14VFONu/UIpx7huGF5eCmTqCx
KnwV7hjCi0pL9DMQAlrWvbmL6GveexjuBTEblHQyeFFH/TnquhinuGIOsTnu/rUN
UT3XdTHQgFD4oL5KSr94bXgDGDSAuMPfNMDeJE1H3Z4+DHx7CO7PJU9hk3QKtqqZ
ztqESiEGPUhc9KkrJWUAErpFZMi/zHAKkVX03AlkWD6CmpwsNjBrdkkKqvtY8AgV
6GP2SK7+/rp+DXCvMh8UlJ5LL7SHC1TUWQXd+bXVsSfr5Cwlngbn1jG+8/pFEyD9
MzUMLyTB8E057S8GwqiSQGANUuuXEq9IkuUdC3daFahyLuheDi727I0J7Eo93iGB
WeIFH47L7ZTWtuhkxsvQg6vIo21KS6GdVh831sPfRsR46husWHyQxslCX+djzRaz
sCQfZ+ZZOwct9XSZk+tN
=OQqC
-----END PGP SIGNATURE-----

--Sig_/HYH+_EOgab7OieVvIn1PjzG--
