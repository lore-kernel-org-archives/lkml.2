Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2CLXIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:08:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47467 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab2CLXIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:08:13 -0400
Date: Tue, 13 Mar 2012 10:08:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Rob Lee <rob.lee@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the tip
 tree
Message-Id: <20120313100804.5534558975eb48c1fd58023c@canb.auug.org.au>
In-Reply-To: <1331572403.1149.19.camel@fedora>
References: <20120309184041.bd10edffa51dcd43ce069487@canb.auug.org.au>
	<1331300109.1149.17.camel@fedora>
	<CAMXH7KHdfzjZCsBMkFOnwYtyaqBztMY99QcZ7VwLP0JASUiVAw@mail.gmail.com>
	<1331572403.1149.19.camel@fedora>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_10_08_04_+1100_cIIP4T82rEcWdei/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_10_08_04_+1100_cIIP4T82rEcWdei/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Mon, 12 Mar 2012 13:13:23 -0400 Steven Rostedt <srostedt@redhat.com> wro=
te:
>
> On Mon, 2012-03-12 at 12:06 -0500, Rob Lee wrote:
>=20
> >=20
> > Looks good to me as well.
> >=20
> > Who should carry this fixup?
>=20
> I think it's trivial enough that Linus can handle it. He always said
> that he likes to fix merge conflicts and has yelled at people who did
> things to prevent them.

Yeah, I just carry it in my tree and Linus will fix it up when he merges
the trees in his.

[The assumption is that anything I can figure out so can Linus :-)]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Mar_2012_10_08_04_+1100_cIIP4T82rEcWdei/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXoHUAAoJEECxmPOUX5FEqacP/iXDadH4uyNZ1ZXzlkOZLaLS
hRbziqfZDheBgPoTsIhNqumEDQProQIZ2HwayUS+EbuVxsTXKnJSLoFu8f4yRWU1
xRXA+VkOOj585czbcnVeDpnqXq3Ur/08vJWEHDL+Vi02mzJUWHxpotswtSZAzNc3
cPacRXoretNDeA0e5TEgYN/bCByKqCIRUfQ1iU80spwMZzLCQchG2aq0NXO6ZF/k
zxkGnj+L21rS+rVyz8R1BCeYvVxSQzim407uq/SXTtn1PieKeALZGdhhGmVLJI9/
WysJTrHYdPqFczQ6rRIXJFBRyKloJ4Q3KIls9euTbk2Uxje4OeXw2zIklDTgKFoT
L0GjMObRnbwh6wNmJe0zeN2in0wg//cjqVpDHBUgmPs3PvdBdYoa7xyfcDCZ4pn6
WUUI0HE6VexP1PEKjZ72/Ibk9q6dGIKgBh7AN2SoFV6xBqkXHZR9NU7CZla6f6Sc
mEbImTvk3SiSAWJIvsHdghQboKPoP3W1WEy1XKvD+8cZNkJH/EtwmWQMPkd58ucf
wPQD0JM/4TURW2/yBAvRpFir7eNc3ZY/xV3itBarDz1qxl7T861stWJquVTxl3p/
WOQ/rZDR7xiKyaYtExbBs+mEKuR9c1r/j4Uw6GSKNuIh5d0exIt0BT74AvnKMEFQ
BjYqaIZvvoVoMXyKNEjS
=PPhE
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_10_08_04_+1100_cIIP4T82rEcWdei/--
