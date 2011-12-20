Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1LTC5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:57:16 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36955 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1LTC5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:57:12 -0500
Date: Tue, 20 Dec 2011 13:57:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20111220135704.8c87c166d9ac18d4ea308107@canb.auug.org.au>
In-Reply-To: <CAB=NE6V12m2_u6YGxhmqjNGs9OjdOKFpCAYu5cs_Hezwwk9LLA@mail.gmail.com>
References: <20111220131802.e3782dfbf8172281a7df5a5c@canb.auug.org.au>
	<CAB=NE6V12m2_u6YGxhmqjNGs9OjdOKFpCAYu5cs_Hezwwk9LLA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_13_57_04_+1100_=aP1n.PIsGjbe5V."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_13_57_04_+1100_=aP1n.PIsGjbe5V.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Mon, 19 Dec 2011 18:42:02 -0800 "Luis R. Rodriguez" <mcgrof@qca.qualcomm=
.com> wrote:
>
> On Mon, Dec 19, 2011 at 6:18 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > Hi John,
> >
> > After merging the wireless-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_postprocess_ra=
dar_event':
> > drivers/net/wireless/ath/ath9k/dfs.c:73:1: error: 'ATH_DBG_ATH_DBG_DFS'=
 undeclared (first use in this function)
> > drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_dfs_process_ph=
yerr':
> > drivers/net/wireless/ath/ath9k/dfs.c:166:1: error: 'ATH_DBG_ATH_DBG_DFS=
' undeclared (first use in this function)
> >
> > Caused by commit 29942bc12537 ("ath9k: add DFS radar pulse processing").
> > ath_dbg prepends ATH_DBG_ to its second argument.
> >
> > I have used the wireless-next tree from next-20111219 for today.
>=20
> Odd, gitweb for wireless-next.git shows only one commit to dfs.c, the
> change that introduced it:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-next.git;a=
=3Dhistory;f=3Ddrivers/net/wireless/ath/ath9k/dfs.c;h=3De4e84a9e62730f3780a=
7eda6b4b00d535dd1d428;hb=3DHEAD
>=20
> In that version of the file I see nothing with ATH_DBG_ATH_DBG_DFS. I
> also do not see it on wireless-testing.
>=20
> mcgrof@tux ~/wireless-testing (git::master)$ git show 29942bc12537 |
> grep ATH_DBG_ATH_DBG_DFS

Yeah, see my comment above .. search for ATH_DBG_DFS.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_13_57_04_+1100_=aP1n.PIsGjbe5V.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7/mAAAoJEECxmPOUX5FEwF4QAKDsaj2RuDT/ZHPXjgxvM85G
hc986UbhbVP6+lLlUPoMpRvQFj1G3A7lm2aRJuzIYfaZFoObDbSIx42g9wGXd1Uy
f4YtKL22HDtEEuPxlCpneawTkVZPm2EmqDIb29MGFP2RjQ2g4ULcBvq6n13sMoE4
aS+BiiCtueVB7S91Dlq/SEOHpLl2RtxIfcQ65yPK8zJ5GBTkWwELVPRYEQQohS1H
F0Hh9fxITTP5qr15kb5lau3RLMtycg87UPoP4hQfDsqCa0fKsfR9NEAqJZ0HPdvm
gV7wCEytApcFaRv4e7ffOoG72w1pull70ExryYiVa1YktntkrehtZl4erQouuHYz
Q/wEsf8X2mjZMJkQw5yvAVzgMhBge6DzUYvobRQp23tOpxmqzGoouPWafYL85NCl
+xNF1v30OG3UfIF3Obrs/n7A33I0OW55tD+0mmrNZtAFHkqs75sL/RAEWrgJCJ4B
GEzALtYWI+Uq/XUdF/IIGbx7cxw3JrgBgoI8lqT+kI1omEmumL0ivZO4Ca/qeojf
gCUJYh+5yxv07b1uwtRcDanxR1570KRDGHnhu6KoyI9fE760mZ8VtT6PB5wcbTsv
xcrONy+Xc1QF6CQXB7GzEweP+nEj8pYSgBVjcWx3myNc5mAKJlUHQZxLOXWDRVVt
C+jSfiXS9oueWFmXdIQU
=Vo7g
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_13_57_04_+1100_=aP1n.PIsGjbe5V.--
