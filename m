Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1KCBPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:15:13 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54109 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1KCBPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:15:08 -0400
Date: Thu, 3 Nov 2011 12:15:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: wireless git trees returning to kernel.org
Message-Id: <20111103121500.9860d492843915cc21bcfdab@canb.auug.org.au>
In-Reply-To: <20111102180946.GC12168@tuxdriver.com>
References: <20111102180946.GC12168@tuxdriver.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_12_15_00_+1100_CWfh6kjizqrlHXFC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_12_15_00_+1100_CWfh6kjizqrlHXFC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Wed, 2 Nov 2011 14:09:46 -0400 "John W. Linville" <linville@tuxdriver.co=
m> wrote:
>
> I have migrated the wireless git trees back to the kernel.org
> infrastructure.  As of right now, the trees are identical between
> kernel.org and infradead.org.  Further updates likely will only go
> to kernel.org, so plan accordingly.
>=20
> The "current" wireless tree is here:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
>=20
> The "next" wireless tree is here:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git=
\\

I have switched to using these.  I also renamed the tres in linux-next to
match your names (so "wireless-current" has become "wireless" and
"wireless" has become "wireless-next").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_12_15_00_+1100_CWfh6kjizqrlHXFC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsesUAAoJEECxmPOUX5FEuFIP/A1tB55F5auHv0qMAdkpPHtv
FSNVw234OGcoTxrUqm6sZC7xWvTgnzbsDrPsXlz/cRdKonMuVVHs1MPbfmWkDjTP
UgPG1RhI5hF0TYWH/qU27fiFWTdGmRAzfkJLd5VKAlRsFSIQTJ//FSKTwRXCp3v4
8vnk5a5B0PkdgEuPn8fXGscxvACkiFXwap7+qBxAebyX7ONda2vFWjT9NfqNu4de
pYf8MhrvafAl8kFQnxJbWlY1Ry0JyH+k0fu2wrRnq7BDRu+H7G3oR9BEbqkMkQbT
/Bl8UNw3RcVDgHcSkQ/UnQXMLhc1qEjBH2O+7U/TMazbcJ2mnkDj5ayCPMXr6d0a
y4tep+5NadYN/SLh3/5W1kFnYLzRxi76Sfd7mBL+x9A+daUBP5idrqi+Cxcssht5
/ysEvBSoIDY/7+ILy+Cpt9aB1//3nr9hlR7zQx2Bohy1CK2/bK1AxcSf/We9DJ1w
VbzPCbiKFcHhGigbkBu6qhl1QaDMwEAsqABXDrhlaVXN74S0CZZc0nlOUYjm0z3Q
OBiwEOvLJ2CJ2s0hRajuhDEZ5miZwy9y3pIQgYtx7DhhhEw4SaNdnC+cZhMZBhZE
JAEHCCnpZKnxbjJhZBPghMH8MmeTnFf9JgnzevLGscwxVhlOCSbLHz3z/5hmySKT
LJWF1ylcthXpRTfpT8gI
=tBTX
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_12_15_00_+1100_CWfh6kjizqrlHXFC--
