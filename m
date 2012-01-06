Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab2AFUwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:52:38 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:40087 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759114Ab2AFUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:52:36 -0500
Date: Fri, 6 Jan 2012 12:52:33 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] pciehp: Checking pci conf reading to new added
 device instead of sleep 1s
Message-ID: <20120106125233.30fba248@jbarnes-desktop>
In-Reply-To: <1324083165-805-1-git-send-email-yinghai@kernel.org>
References: <1324083165-805-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/moVEBvgd//6WJmn/XNno2DT"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/moVEBvgd//6WJmn/XNno2DT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Dec 2011 16:52:45 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> During reviewing
> |	PCI: pciehp: wait 1000 ms before Link Training check
> Linus said:
> >...
> > That's a *long* time, and it's irritating to the user. It makes the
> > user think "the machine is slow".
> >...
> > And quite frankly, an unconditional one-second delay here seems bad.
> >Two seconds was unacceptable, one second is just bad.
>=20
> Try to access the pci conf of pci device that is supposed to show up in 1=
s,
> if could read back valid vender/device id, could bail out early.
>=20
> Related discussion could be found:
> 	https://lkml.org/lkml/2011/12/6/339
>=20
> -v2: seperate code to pci_bus_read_dev_vendor_id() from pci_scan_device()
>     and reuse it from pciehp code. Suggested by Matthew Wilcox.

Kenji-san, you ok with this one?  Any chance you could test?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/moVEBvgd//6WJmn/XNno2DT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB18RAAoJEIEoDkX4Qk9hAEIP/1SiZHQVuU7rxXhdJSqYGQPb
N9w8Znx5TfveLwdwP7foEk4kp9jVyiLdVpuTZzhJ5np5Zsq72srMOQe+Y/LFxiMq
VFBESOUzk7htolgECylXxyI0wVs7hWnRcwiKrriYa7VD8RQQMRIC6st/YeF6oex7
cD1i0zz1ojiFigvnMApZ9FRFlDqYTNEyFeuVfPNGPGR4JiEOrbKTnxMr8flqgdGr
oOOPiLh+ate3+Pvk+mp0VRHPpsNYukxBTUK/iMHX+SGESmtmwIcb/pHlHJJ5dZW+
ocyF1V3T2lxkqetfKFsMuz3W0n+TxgcntNPRuBPwBuUfNAND9cXatVzhRQGC7GPj
uSs4kygaosnknZ1419l+sWhKPoLXjh5/wBeLbeVZQEuUBDfZR3NU3jaRhzEfJhDk
0ZiMClwjc+kjTuD/D0dKxIDEE+dPeKeFq0kFk87Pvs7yAx7MGvtGHOOzr2ONyrDK
l06Lk1Pag4eFutlmQR/CRB0ian8v8p7SlDMYOKKcNdR8sScqQmQ9w5Be/7rKcBoY
ffCMZx8VnbSUhYEBZufxzdRqtEri+E9lZxy4XBaANmpzgPlImiDpKMwqw85+qJ3m
Af9P0iX8h6pULJZmRZIA/P1tfueiVNnUz6n6FRVV+tcrNfIEABSUK5I461a8jv2O
BO2j2rtylMUKujECStjr
=KsPK
-----END PGP SIGNATURE-----

--Sig_/moVEBvgd//6WJmn/XNno2DT--
