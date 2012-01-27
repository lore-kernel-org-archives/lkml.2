Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2A0Tn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:43:59 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41795 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752631Ab2A0Tn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:43:58 -0500
Date: Fri, 27 Jan 2012 11:43:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
Message-ID: <20120127114350.3581b15d@jbarnes-desktop>
In-Reply-To: <1327690515-2991-2-git-send-email-yinghai@kernel.org>
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
	<1327690515-2991-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HjmFpBjcLjd5K87FF/CvMGX"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HjmFpBjcLjd5K87FF/CvMGX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jan 2012 10:55:09 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> When hot remove pci express module that have pcie switch and support SRIO=
V, got
>=20
> [ 5918.610127] pciehp 0000:80:02.2:pcie04: pcie_isr: intr_loc 1
> [ 5918.615779] pciehp 0000:80:02.2:pcie04: Attention button interrupt rec=
eived
> [ 5918.622730] pciehp 0000:80:02.2:pcie04: Button pressed on Slot(3)
> [ 5918.629002] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status: SLOTC=
TRL a8 value read 1f9
> [ 5918.637416] pciehp 0000:80:02.2:pcie04: PCI slot #3 - powering off due=
 to button press.
> [ 5918.647125] pciehp 0000:80:02.2:pcie04: pcie_isr: intr_loc 10
> [ 5918.653039] pciehp 0000:80:02.2:pcie04: pciehp_green_led_blink: SLOTCT=
RL a8 write cmd 200
> [ 5918.661229] pciehp 0000:80:02.2:pcie04: pciehp_set_attention_status: S=
LOTCTRL a8 write cmd c0
> [ 5924.667627] pciehp 0000:80:02.2:pcie04: Disabling domain:bus:device=3D=
0000:b0:00
> [ 5924.674909] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status: SLOTC=
TRL a8 value read 2f9
> [ 5924.683262] pciehp 0000:80:02.2:pcie04: pciehp_unconfigure_device: dom=
ain:bus:dev =3D 0000:b0:00
> [ 5924.693976] libfcoe_device_notification: NETDEV_UNREGISTER eth6
> [ 5924.764979] libfcoe_device_notification: NETDEV_UNREGISTER eth14
> [ 5924.873539] libfcoe_device_notification: NETDEV_UNREGISTER eth15
> [ 5924.995209] libfcoe_device_notification: NETDEV_UNREGISTER eth16
> [ 5926.114407] sxge 0000:b2:00.0: PCI INT A disabled
> [ 5926.119342] BUG: unable to handle kernel NULL pointer dereference at (=
null)
> [ 5926.127189] IP: [<ffffffff81353a3b>] pci_stop_bus_device+0x33/0x83
> [ 5926.133377] PGD 0
> [ 5926.135402] Oops: 0000 [#1] SMP
> [ 5926.138659] CPU 2
> [ 5926.140499] Modules linked in:
> ...

Ok applied this series, thanks Yinghai.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/HjmFpBjcLjd5K87FF/CvMGX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIv52AAoJEIEoDkX4Qk9h1JQQAMsPITMXXoWZbgI4BwJkQV8b
MF0UhOkOfaW0ymIsiMQYlyWY8V4he7vN3A4QYfdiih6CW6jiwGXf02FaUHmT8Mj2
DRF7vB1UjvgKkeO9DRbzYSy4o/+RJN19WErnBWODmj+CRDS9v4LEClIlcs8TMqV2
AjmQSfFC5VLa7BgTEpIyPLjfXQEbqWUrBP9du4hpOEzUVc0l26fnPR8RgwzhTiVV
2eV1ENykP0w4K1dCrpPAx4j9BkbHLXklfvVR06DY9uoR+MGkERQCaucUfPwu1uBv
x4IlKMBmF5K3mEAnLqFO9JjciVZD7efFPNt+6zuaofZBSjDhUuez+2r5jdvAz/dv
EABx6DluIiOEhnRAy26P5feIfYWIdfokYcNYws/QaHQRVUMBkHeoIgc85/nsdPfr
OeIJ4IMRdOWM3k2NyhYQg+omGLwXSuEkK2/7YimOz4UZOPA0Y9kUA4r0LOFmgaBU
wuvH1SbAPjLEKLY3uFpCGIrlPlD1Iz4AtHgF31sI6rKykM+zkB+RlBgsZdLQh14S
b7xTRygqCvGv25N6n/zeXRB0E37jRE+llw2m+8Qo4BnQTMsmB4BYVBPzQNykZu/C
Nz67Zmwh2lS10mPYZB3p040h2QTnRTHzv4viRlUI7pc8LgVc0vqDm6mICOSXoU6v
+DPQPea/gWirVwl9n1Wy
=q1+c
-----END PGP SIGNATURE-----

--Sig_/HjmFpBjcLjd5K87FF/CvMGX--
