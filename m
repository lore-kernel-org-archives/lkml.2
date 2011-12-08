Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1LHV5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:57:55 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:32820 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1LHV5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:57:53 -0500
Date: Fri, 9 Dec 2011 08:57:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Dani Keerikoolparn <danik@qca.qualcomm.com>,
        "Hoefel, Guilherme" <hoefel@qualcomm.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next base Linus tag
Message-Id: <20111209085740.a23a0295a5ea15ab51169f3c@canb.auug.org.au>
In-Reply-To: <CAB=NE6XDHL8mexe49TSoug3COh11RAvVY339Ntj0MJdw96wO1w@mail.gmail.com>
References: <CAB=NE6XDHL8mexe49TSoug3COh11RAvVY339Ntj0MJdw96wO1w@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_08_57_40_+1100_eACj46DYQfRC5iDX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_08_57_40_+1100_eACj46DYQfRC5iDX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Thu, 8 Dec 2011 13:39:16 -0800 "Luis R. Rodriguez" <mcgrof@frijolero.org=
> wrote:
>
> If I know a linux-next tag, say next-20110928, how can I extract the
> Linus tag you used to start that set of merges for linux-next for?
> That is, I am assuming you base your daily linux-next merges on that
> day's latest Linus's rc cycle (not just Linus's master tag of that
> day). Is that right? If so how can I get that tag?

In each linux-next, there is a file called Next/SHA1s, and in there is a
SHA1 for "origin" - that is the point in Linus' tree that I started for
that day.  I just use the latest available version of Linus' tree each
day.

> For example for next-20110928 I see in Next/quilt-import.log:

For the quilt series, the owner of the series puts a BASE or NEXT_BASE
comment in the series to tell me what their series is based on.  I import
each quilt series staring from that base into a branch and then merge
that branch.

For the git trees, I just fetch and merge them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Dec_2011_08_57_40_+1100_eACj46DYQfRC5iDX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4TLUAAoJEECxmPOUX5FE7SkP/2Jw1AUIktFCBnO5HrCtbLAO
cN9bBxGV9AoV+Jz2f/91SpFHM/VdmynK4kcRelMWBnELzsY5Fsphygu86lskfjci
v7hqroncLhMgjxIqQNS+adt+dTN2Y/7DjYxBQHO533Hh4nY29cndoW4vMgZANyim
lK1d86kI8VtHYiYrKqsr7DqUddjQx/inVnk+jUbTd6aAcbqs70Nq2THcjX0WSxKU
ZKidiaHDwaU5Uk6KspPzl04pIPWXvJBQ0PogzHbKDFwduCVScaLqmv0vhGoZ9pzA
PMO0dEuXWDd8YxEbNhQMuaNT2CpmG4+DP86nofYBbMlNlOYyM8uPtwPQhIeAgcQD
fdjtrAnHEM+h9ZmcA47w5QrDSjcAtO4ujC6fJjzN9LC4vghEzbihPlbK+YLvck89
eM1vdKMyJH8jMXZK/hqA4dtb5gB/49m+3RN0NBieTEkbQsHq1Snhd1AiDJJ91/nc
NxoJ9anPUag60ywfP/ts3rlGa8LnEW6L2hKC9xSvkDAHe+zYIP70VQPw5RSacBJB
uw3eCoro9Uxl+EMVNvkoeDQOVde9HmfTFR3DW7CNS2dvDQgNMPBC4wZe1cQ47mkI
7jtWyaGmp37Q7b7vjlu7D1POXLcrhyZX+vRd0hnInojK3AVR3YSIGX2DgCABfQeE
eLJ2FwZYYdouuKKmBwpC
=5SR6
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_08_57_40_+1100_eACj46DYQfRC5iDX--
