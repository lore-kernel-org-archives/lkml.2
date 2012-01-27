Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2A0SgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:36:06 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57989 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753731Ab2A0SgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:36:04 -0500
Date: Fri, 27 Jan 2012 10:36:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] PCI: pcie hotplug related patch
Message-ID: <20120127103601.09e3f771@jbarnes-desktop>
In-Reply-To: <CAE9FiQUFYcaVWorPPP7PQqiBPnKv-iBkPm_qbGz4T_xLR2THiQ@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQUFYcaVWorPPP7PQqiBPnKv-iBkPm_qbGz4T_xLR2THiQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ew2DPY4uNs5K0M=GNBx.pB2"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ew2DPY4uNs5K0M=GNBx.pB2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:26:46 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On Sat, Jan 21, 2012 at 1:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > b40c9ef: pciehp: Disable/enable link during slot power off/on
> > fe877ae: pciehp: Add Disable/enable link functions
> > 292e286: pciehp: Add pcie_wait_link_not_active()
> > 186b3fd: pciehp: print out link status when dlla get active.
> > 2781df4: pciehp: Checking pci conf reading to new added device instead =
of sleep 1s
> > bf1c4ac: PCI: Separate pci_bus_read_dev_vendor_id from pci_scan_device
> > 601c6f1: PCI: Make sriov work with hotplug remove
> >
> > =A0drivers/pci/hotplug/pciehp_hpc.c | =A0133 ++++++++++++++++++++++++++=
+++++-------
> > =A0drivers/pci/pci.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +
> > =A0drivers/pci/probe.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 48 +++++++++---=
--
> > =A0drivers/pci/remove.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 28 ++++++++-
> > =A04 files changed, 169 insertions(+), 42 deletions(-)
> >
> > First one is for hotplug with sriov under bridge.
> > following two are for hotplug probing with pci conf reading.
> > Last four are for pcie link disable when power off slots.
>=20
> could be found at:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-hp

Ok I dropped the earlier link state check; can you re-post the series
with Linus's comments addressed?

Kenji-san, do you have time to at least review these?  Testing would be
nice too...

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/ew2DPY4uNs5K0M=GNBx.pB2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIu6RAAoJEIEoDkX4Qk9hNZ8QAKyXfZO4zjYP+W6cZ4Eqp4W5
SwfmdWW2vBjAZLO9sAd255PBzeXvlrehEpb+Zy4DN/XGHe5viBZN4FDDGiTwSfZx
6El0z18w92fc48KdK+DGvFUWSrGqIhYJUY48d6e7UHAulx1VkNTttNYM+MeJATKX
dbJAoPduREkRLV7U0aSEi+vBqCwwshaMBnuDfMc9XaYTfXgpO1z169LuHjgZUhqe
Xcg9F70u8lqQgoqQW8OtH1qu8tSbLvmQxLPD7ii2n7wL9pdnRY/Ij1a0wj+Qci9X
jHt7cTjdWHQPD0LNfeGRROZl9kTiFmSbDtXWVfEa10ApDpdNDWMUVh9/da5v5Qh8
sGXxNP9qWKfsns/707/KL1AF368p+JFOnv4+bIKbKGJSzI0seQCfn95wKnU0Wchz
DvkMl6ETuWiq0rlWxZREAVyOncTLbN5OK78AtMD6oCssen4V02EPS5c/dGqW/Z9J
rvU1VCCTKuMTGh1avpi0MuQqGeFYRkFqkQRfAxDwJrsMf1+1D4PHJgDWch1QRtPv
Rixq+g0k5cmMFIWkol7UMhPBjGISIHrXnt2hJ8Q4ZedlxPMcnyZEeAtwsXJlJKsZ
ABIMjxXvYKb5saC0E3zvnSyjRrjZdm+YwsYeHG2iy6/3IzR7WpWvAJIxS7g+voPD
4VVuKiKPaJ3WbMtLXCig
=Er01
-----END PGP SIGNATURE-----

--Sig_/ew2DPY4uNs5K0M=GNBx.pB2--
