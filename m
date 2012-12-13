Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab2LMXDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:03:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38702 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2LMXDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:03:36 -0500
Date: Fri, 14 Dec 2012 10:03:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.8 merge window
Message-Id: <20121214100326.09a0290391cf39d6da96710e@canb.auug.org.au>
In-Reply-To: <CA+55aFxXgEL5997fgzbhvKAUtfTPsUKXpk5MMBKWYpmZzX2JtQ@mail.gmail.com>
References: <20121212123519.GA11549@amt.cnet>
	<20121213081935.90098f39e6da6ee17e902324@canb.auug.org.au>
	<CA+55aFxXgEL5997fgzbhvKAUtfTPsUKXpk5MMBKWYpmZzX2JtQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Dec_2012_10_03_26_+1100_Ww0hM9dQ5Q7YLCFB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Dec_2012_10_03_26_+1100_Ww0hM9dQ5Q7YLCFB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 13 Dec 2012 14:22:34 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Wed, Dec 12, 2012 at 1:19 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > There is a section of this tree (the kvm-ppc tree in linux-next) that h=
as
> > been rebased before being merged into this tree.   Alexander, please
> > don't do that (especially since it has *not* bee rebased in the kvm-ppc
> > tree but more work has been added on top of it :-().
>=20
> Christ, why can't people learn?
>=20
> Solution: I'm not pulling this, if it means that we will have
> duplicate commits somewhere.

Actually only in my tree (until Alexander cleans his tree up).  I am
going to have a conversation with Alexander about process.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Dec_2012_10_03_26_+1100_Ww0hM9dQ5Q7YLCFB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyl6+AAoJEECxmPOUX5FE9d4P/1GEVUGiV5rghGHDCGNJ1t+X
htwzY9nLWwMUyQQ5fxPDFjb0w6cVcYqiR3yE6DLKixXeNmB6eYVYgF73WPwdj9LN
koxBfIMNTh6NR3khajfnh23Y3jnDMlmxAWNpjdKX8gF/utyTnLAJHdx4jZqxen1U
k39+iPCGIcFsf2brWpugEBKazWA1x1+9zb3sfFULLu21BnNz3vAQq8DEReNKRJls
Q0Pnj+R/h7v3DPAxba/DyCr4VM2puBut4q1TdLMwHIPpjCasaXQRFjm/a+/Xr0yd
G2U2fPUxcitUdgPBz65PkkByMAAMZYrO0Y4a5dHeFYMRRQ2QOTyG85jtvotz/Gk1
Zpj95OMM2Gvl6hsB47mk9QZZdHfunGWX+MMtdi8i1I3M8Xl9qcVRG4b2c6LA0Qbx
Mx52Zsq28p6aPf1YcI65Iyuo3Z5yGyOWp+nkO1KJlyCkmlJx9lvlbNUzwreZf/TM
ZSyYySYz6IodHNK4E5rABMcKZl6O66eP2KvdA8CFaLkc6dqLO09eGfWZWHfAe+Rb
nHdrz7DKtoFeAMPVO2hxozPe6Z6Y8bDTjauM4webwGiJR86iIkCvsANNJFBdaJJ8
cka/Yug+0CL2aMwwd9vMl7QPegHYusVxqEmI9VjuFn67Fio5YgVomV2bB0n1PR/m
MJdDrype8/GTgc+sSUPv
=rj6B
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Dec_2012_10_03_26_+1100_Ww0hM9dQ5Q7YLCFB--
