Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2GILQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:16:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39770 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab2GILP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:15:59 -0400
Date: Mon, 9 Jul 2012 12:15:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?utf-8?B?546L6ImH6ImH?= <wtt_usst@163.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: Ask a question about regulator always_on and boot_on
Message-ID: <20120709111557.GB3934@opensource.wolfsonmicro.com>
References: <62bf0a51.4b10.138699255c2.Coremail.wtt_usst@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <62bf0a51.4b10.138699255c2.Coremail.wtt_usst@163.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 10:29:54AM +0800, =E7=8E=8B=E8=89=87=E8=89=87 wrote:

> Sorry to bother you.

You appear to be asking exactly the same question as you asked last
week (and this is also the second time you asked today...).
Unsurprisingly the answer is also exactly the same.

> When I set the regulator always_on and boot_on item as 0 at the initial s=
tage.

> The regulator should not enabled, right?

No.  always_on means that the regulator will never be disabled.  boot_on
means that the regulator is expacted to

> Why not add these code for the obvious operation to disable the regulator=
 at initial stage?

The goal is still that the system specifies full constraints which means
that any unused regulators are powered down.

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+r1gAAoJEBus8iNuMP3d3dcP/jr4BPyCaCyYL5VlmEFARo8K
bvPzUG3D2GpFo2tnMGy6R9SE+BCJD1GKtr59/tY0vhrGyFfvWqEht1PqH8Wum2HC
dHHpwFGnQeE4Y/4DMp467y3IjmFcaA2exl0Cey0qbDgxHJwzZSGtk/L1H14xu8an
kp141oMW5yul7ui6lvBt7UE9v0KKYSk9GxrIka+e2KlvTFATQJJmPO1pGaNKqrhW
8oGQUdFRFFmCDogJkMMvYYRJKDwlnevZ5ilZF8R1/oaiUoAAnXnDYVmPzggdGQMY
SRni9ZNuw3xDjwOv7Ot6Q9fYhHZG5vUJJL4U7uNawTkMPQ7cpJCYxlI0+2jAeT3g
mwxOwT36G0T8fUJAJjh2Tx7jTmGqPyhoeF/i6k6HopN1I4Wkfckln3fwbBCgkANU
yHCsVFv30dzMB8at3NjONVmuUXpiqtLOJH3/tFugtYs/Dud4AcUwNC9/NzzcLADo
8AzS0RBRkRlA8zLAG5th+N0NBp8VeWTH9BclrZdBEKIePsBXKAL81Yhj8JPWOXl8
hK7ZCSy0mM+Vs/1qpoIKkDkr94zk9Rom48JXNnCqGmCZAPlAJ0vE+59wsUyJSxHC
fKoqgjaJ/EdbEg1zrI+yhtqacT5/xXNyr37Bt5p8Oqe4kVECIbAYb2faNZHjFSMY
OMwn5Lm9xU5Sue7DrwEG
=X8xK
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
