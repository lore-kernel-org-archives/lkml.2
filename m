Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab1IPAyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 20:54:43 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58778 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1IPAym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 20:54:42 -0400
Date: Fri, 16 Sep 2011 10:54:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Temporary MFD tree location
Message-Id: <20110916105433.f8a03317ee4172c7e318be83@canb.auug.org.au>
In-Reply-To: <20110915100626.GA32263@sortiz-mobl>
References: <20110915100626.GA32263@sortiz-mobl>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Sep_2011_10_54_33_+1000_Mbxbb0P6xKzhaE58"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Sep_2011_10_54_33_+1000_Mbxbb0P6xKzhaE58
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Thu, 15 Sep 2011 12:06:26 +0200 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> Since kernel.org is still down, I temporarily moved my MFD kernel tree to
> infradead.
>=20
> The URL is:
> git://git.infradead.org/users/sameo/mfd-2.6.git
>=20
> And the branches are identical: master, for-next and for-linus. As with t=
he
> kernel.org setup, you'd want to take for-next for your linux-next tree.

OK, I will switch to this tree from today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Sep_2011_10_54_33_+1000_Mbxbb0P6xKzhaE58
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcp5JAAoJEDMEi1NhKgbsap4H/3gX0BrIwPDJxNF0UCEe1vqh
KRi1NErCwsT+lN5xjJcvmgq23VMkeri+6LiIRMrVOP6VBhcmtOY/A6qMdmlX46y9
1YYrj1raOeoqK3a1m01UcCcm4z6hmDufRAx71HtquZpvXAEP/lk7IhjqalMx768P
6YuTX/RXdIU8WuaPUFIoOGiXXGFZdkAU5i4fsFI34BdpoY4Vmlqz8yM/F4pnH0c9
JMkZlrIi/49aHju8SMIowHOxYzbC1uvQI8mb7a5qSKteMC4uzVu6m6TZLsT0VfVI
DsZaikh28mOc3VDiZC3tYHJI/j3Lnfit34cdQ3mkU3wiEc68rTXa87Og27TYSNc=
=X5yC
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Sep_2011_10_54_33_+1000_Mbxbb0P6xKzhaE58--
