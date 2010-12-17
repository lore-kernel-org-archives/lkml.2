Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0LQA7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:59:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38484 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0LQA7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:59:40 -0500
Date: Fri, 17 Dec 2010 11:59:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the ia64 tree
Message-Id: <20101217115932.a633519e.sfr@canb.auug.org.au>
In-Reply-To: <987664A83D2D224EAE907B061CE93D530193D00A15@orsmsx505.amr.corp.intel.com>
References: <20101217112357.ec7879f1.sfr@canb.auug.org.au>
	<987664A83D2D224EAE907B061CE93D530193D00A15@orsmsx505.amr.corp.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Dec_2010_11_59_32_+1100_TjhyAP4H7=CvzUK4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Dec_2010_11_59_32_+1100_TjhyAP4H7=CvzUK4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, 16 Dec 2010 16:50:14 -0800 "Luck, Tony" <tony.luck@intel.com> wrote:
>
> > Hmmmh. I wonder why I didn't see them in my build?
>=20
> Ah - because I only built against Linus' tree, and linux-next
> has:
>=20
> commit 3b38bb5f7f06356a89bb2cbf92ad346025e95192
> Author: Huang Ying <ying.huang@intel.com>
> Date:   Thu Dec 2 10:40:53 2010 +0800
>=20
>     ACPI, APEI, use raw spinlock in ERST

That commit is in Linus' tree as of v2.6.37-rc6 so if you merge -rc6 into
your tree, you can fix the conflict there.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Dec_2010_11_59_32_+1100_TjhyAP4H7=CvzUK4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCrX0AAoJEDMEi1NhKgbsIiIH/iFhRzu9nFWc/OXBNS/YmgXL
VqE47WLPfN61l66jLPfGOjGuGetzhoYKlLVohA2e5VVRbKVPLn2Cl5QvhJVaOpFN
5Khrb7iJWLiqL+7UulLw7oI7skc5fDlsc/lFNZTLCfcT8iBZsfkYgAgYIHGsTyN1
Kgnjaf3k+XVAiwI8Q0lWARKbURkDcXkKXw2OylUeH9G2TzIOAeXLzB80pzBlz3ha
Ug3e2HDfaxJcblUmL0Lj/HF0AeInxOfu7xS3QD6thgPl8BtK7FtEBjSCm5On/bHG
eqZD3sqCl2xtvuMw24Rp3Uyih2TzMvo9yllyeFHWmDF0HMcZbmSjgS1Za4/Yri8=
=NPD6
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Dec_2010_11_59_32_+1100_TjhyAP4H7=CvzUK4--
