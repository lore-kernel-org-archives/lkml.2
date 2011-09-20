Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1ITVOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:14:50 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60926 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1ITVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:14:49 -0400
Date: Wed, 21 Sep 2011 07:14:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: linux-next: manual merge of the trivial tree with the
 kernel-doc tree
Message-Id: <20110921071440.b56b5eae5178a3f71bc72e92@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.1109201504040.13109@pobox.suse.cz>
References: <20110919163946.9165592b447bf5b578146f83@canb.auug.org.au>
	<alpine.LNX.2.00.1109201504040.13109@pobox.suse.cz>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_Sep_2011_07_14_40_+1000_pPTxpMLEon.Xfvmz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Sep_2011_07_14_40_+1000_pPTxpMLEon.Xfvmz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Tue, 20 Sep 2011 15:04:45 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:
>
> I don't know where to get either linux-next or linux-doc at the moment, s=
o=20

temporarily, git://github.com/sfrothwell/linux-next.git

> just correct me if I am wrong -- I will just drop the=20
> Documentation/PCI/pci.txt hunk from c460578a674f in my tree, right?

Yeah, I would guess so (Randy?).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Sep_2011_07_14_40_+1000_pPTxpMLEon.Xfvmz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeQJAAAoJEDMEi1NhKgbs1LIH/1ZymLlFmuB/T0IzvTgNF1+L
8305fNnKwZOEFfLllEfg3pGk1+PUilyz59KIOJKijwr/5fJCzVZ1s6X/NHSuL7wS
NWf5/A91ZXfKm7+f+laitHv7Y5gxIlR8qEsfN92aj2EAsxAPIdqNwjfWKhvbN/uE
j99742SiF/+znM42ANsN3HW/VBpjHuL+oghXfstuPtoVMfGuUXKFxEKJfjJV8INX
ZDtC9o5mzYV05LnW4OtRqj1pZYg0RWtym4b2RC1nS2dmsSQjCc6lxGIVxVquW1K7
gJDbwE6mexes/tpz6svnl+lVGZp3YDkab2e7B6RTnBZn6xwSw4s1Z8kA+KdpHjw=
=hC6g
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Sep_2011_07_14_40_+1000_pPTxpMLEon.Xfvmz--
