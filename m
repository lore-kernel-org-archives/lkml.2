Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1JDIOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:14:19 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55664 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1JDIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:14:17 -0400
Date: Tue, 4 Oct 2011 19:14:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111004191408.8f211d359d9e5d7b65129c4c@canb.auug.org.au>
In-Reply-To: <4E8AB741.9030707@qca.qualcomm.com>
References: <20111004180333.44f741dc08063a918c9b581f@canb.auug.org.au>
	<4E8AB741.9030707@qca.qualcomm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_19_14_08_+1100_OgMS7/LWXgk_Z5.d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_19_14_08_+1100_OgMS7/LWXgk_Z5.d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

On Tue, 4 Oct 2011 10:35:29 +0300 Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
> On 10/04/2011 10:03 AM, Stephen Rothwell wrote:
> > After merging the moduleh tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/net/wireless/ath/ath6kl/debug.c:237:11: error: 'THIS_MODULE' un=
declared here (not in a function)
> >=20
> > Caused by commit 9a7308341b71 ("ath6kl: silence "invalid rate" warning")
> > from the wireless tree interacting with the module.h split.
> >=20
> > I added this patch:
>=20
> John&Paul, how do we handle this patch?

Since it adds an include of export.h (which only exists in Paul's tree),
it goes into Paul's post merge patch series.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_19_14_08_+1100_OgMS7/LWXgk_Z5.d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOisBQAAoJEECxmPOUX5FErDsQAJCQd4pGKKw8Eca6rXZajN4t
oxUUM1s/LEPChhI/sUcB6mpXaQB70dOU+wxI2IamCE+eFXCzUZWTQ6V+fTC3/Fgt
GRsbDVIOfMgtrSJYuvJC78N7/dlvYK84cYkf2XFJCB2J/PNnunrMELxIn17yZbBr
pcVeoLdD46wHRHN9lKFAFwOFdEKtCNyfG30yYvcwybfO0oPICmJOPUHtFtnv8krS
p8KF6PM54TDKPe09yyP0ljf+R5oS+jrCmIa1TM2wRH6vD3yS5iHLwDMhpClxWcel
5i1i2Wp3XpxX614ov+hz6CeKl2xI1lhmnftCX+C4FhlwzsAxzlYxkOh5QoyETub4
2lvOUjSXtKL/SQm/RTC2gjK9f/bvAIGaarYF8hQfvv9sI6kXaPAmDHttoooqbhSX
sAk8DBAW5XeCVel3SlHZ7z4Unlrp9wavzwwtVYkyN2vEtsuSmCmD7D9qgvUZqFho
kj4c0nBajtt66tRsvUUP59WtTueVYmOu+uWho4NIIulaX7Z0YJjDabm2QM/LdamZ
UU6Tjpr7GeB6H1EjQ2N0NrwibD48imxR4ViG8EXo83Wup/r1BvCsuKT7NWkdvuhY
3M3MrPW4yqikPXGmzasMiZuCDckqKFao1U155RvB3ylTxhCFw1sDCZAyex08ulk9
Wg+eHsDMYnM2eoX5ZPro
=w/T1
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_19_14_08_+1100_OgMS7/LWXgk_Z5.d--
