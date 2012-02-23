Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2BWUKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:10:13 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:48101 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756806Ab2BWUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:10:09 -0500
Date: Thu, 23 Feb 2012 12:10:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: fix memleak for pci dev removing during hotplug
Message-ID: <20120223121002.0572b9db@jbarnes-desktop>
In-Reply-To: <1328948310-14748-1-git-send-email-yinghai@kernel.org>
References: <1328948310-14748-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qmq+9=X/5XqXa7Pq1xNbS0l"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Qmq+9=X/5XqXa7Pq1xNbS0l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Feb 2012 00:18:30 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> unreferenced object 0xffff880276d17700 (size 64):
>   comm "swapper/0", pid 1, jiffies 4294897182 (age 3976.028s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 18 f9 de 76 02 88 ff ff  ...........v....
>     10 00 00 00 0e 00 00 00 0f 28 40 00 00 00 00 00  .........(@.....
>   backtrace:
>     [<ffffffff81c8aede>] kmemleak_alloc+0x26/0x43
>     [<ffffffff811385f0>] __kmalloc+0x121/0x183
>     [<ffffffff813cf821>] pci_add_cap_save_buffer+0x35/0x7c
>     [<ffffffff813d12b7>] pci_allocate_cap_save_buffers+0x1d/0x65
>     [<ffffffff813cdb52>] pci_device_add+0x92/0xf1
>     [<ffffffff81c8afe6>] pci_scan_single_device+0x9f/0xa1
>     [<ffffffff813cdbd2>] pci_scan_slot.part.20+0x21/0x106
>     [<ffffffff813cdce2>] pci_scan_slot+0x2b/0x35
>     [<ffffffff81c8dae4>] __pci_scan_child_bus+0x51/0x107
>     [<ffffffff81c8d75b>] pci_scan_bridge+0x376/0x6ae
>     [<ffffffff81c8db60>] __pci_scan_child_bus+0xcd/0x107
>     [<ffffffff81c8dbab>] pci_scan_child_bus+0x11/0x2a
>     [<ffffffff81cca58c>] pci_acpi_scan_root+0x18b/0x21c
>     [<ffffffff81c916be>] acpi_pci_root_add+0x1e1/0x42a
>     [<ffffffff81406210>] acpi_device_probe+0x50/0x190
>     [<ffffffff814a0227>] really_probe+0x99/0x126
>=20
> Need to free saved_buffer for capabilities.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Qmq+9=X/5XqXa7Pq1xNbS0l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRp0aAAoJEIEoDkX4Qk9h3iAP/1Zv2L7ivjgW7j/Fi5UBwa3h
JB6bZ32FLuueJPcJbQr56pEv7lrcjuYxFVCt0lsfhRGN165cjD5v+FmvHNsOQ04R
ed8GA+UrfS1AY7JzVzMUN4UMmgzGClz8NfDMYO1fC9y4mvScyoE4UDIDFFfzBNeZ
+xjcCLM95LuZxMmn/gCZLBU+KHSG6LFzxZ+NLs171dKaZUQjQNaYba7wkcmy/SPc
Qm1f+RxysXs+pFuP9d28hk9ZpWIbCd6C5xI34sF7YTcK1GH2bB+riFlMKEQVoUAD
Cijr95nK9Pl8wRj2R3PaSrFeHl2qywSg4B5FvcncPeNIvCXNbUZ0z6g6vyFSSsWp
Z3PHdrVI4vVfj/zL3u/UTmvQQ8ck4pPoaySfbNbZJk7mejuDXYEF/C3Zdq2I+e/x
/NGG17hOkdvCdFwQopo4O9pNAfeszxm3c0tqB/IfZinQRyAqsCMc+toCOWGEjIOz
CV+q5lxI5dU2hSl3fgHUbuq+2IupxHnu7GvAbifkeB7zz/C5tLtBU/iBhIt0fbnT
ZQqsAwPRIv6uA6MnTCs2PK6HRZEcrUJPMMMsiIKmWlaVvYN5Uo5WUbNwADZzg97u
8xSdkumy0wBw+7Kd/2S1El8tjwSebmWYTRi2eEEdFdtX3MaiRXtQmJzPmq5xi6Lg
enjJeY9zBSmzb1+/5DBg
=YGqm
-----END PGP SIGNATURE-----

--Sig_/Qmq+9=X/5XqXa7Pq1xNbS0l--
