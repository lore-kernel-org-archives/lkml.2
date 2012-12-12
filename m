Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2LLVTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:19:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40665 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2LLVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:19:44 -0500
Date: Thu, 13 Dec 2012 08:19:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.8 merge window
Message-Id: <20121213081935.90098f39e6da6ee17e902324@canb.auug.org.au>
In-Reply-To: <20121212123519.GA11549@amt.cnet>
References: <20121212123519.GA11549@amt.cnet>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_08_19_35_+1100_XRySf42qdbHnbFer"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_08_19_35_+1100_XRySf42qdbHnbFer
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcello, Alexander,

On Wed, 12 Dec 2012 10:35:19 -0200 Marcelo Tosatti <mtosatti@redhat.com> wr=
ote:
>
> Please pull from
>=20
> git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.8-1=20
>=20
> to receive the KVM updates for the 3.8 merge window, including
> considerable KVM/PPC work, x86 kvmclock vsyscall support, IA32_TSC_ADJUST
> MSR emulation, amongst others.

There is a section of this tree (the kvm-ppc tree in linux-next) that has
been rebased before being merged into this tree.   Alexander, please
don't do that (especially since it has *not* bee rebased in the kvm-ppc
tree but more work has been added on top of it :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Dec_2012_08_19_35_+1100_XRySf42qdbHnbFer
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyPTnAAoJEECxmPOUX5FEGLsP/RweN+TQkBJhMfFoZO/10fJL
gX2efbsTxqRmrtKGrHQVhlGdUfcG3kRC4dWRquOu7VDyvqjUlQSi5zJqwUSVeH1l
XrsSAC88gyBGxNdiOUddQ+lh4tmEBfzl+1OOjYzHxC1xcdc8pcNlGU8Rtb7Yk8oa
QXpep7ddXF4pIIGDTcdolc+QbfYln+pr1DauWcfWbqs/Hbgts+53q7J9Mz7YrtQG
FCVeBkM4Shu0yoLn6HdLfUub6K16gCzFcqEdmrHVWOI3EWkn0eef9y0xvfI+z8lH
0DyEakoyZaoFpJaVDU2eS8RXPucZhQ+Z/iNIHlv8DNV95jgWlEE/AN3pqN0QWQ1O
ib6RneWGQ8q7ZKoNmygs8ESDWw9edEC5dR04Hfah5Dc+h8QnBxCZhWOohGMVx9ua
6D7gUeD3CeDPxfr0H18U93GR8AeLVPSlEqDeZ9FUZSVqqqMChMR+9/1PiBRZytiG
/ea5qMyB+QxEZzpPHCxBhwG0uggB7nN5tyghxQNpJKQGWro5nY2Ku6aH/epEvRYH
d1u2VCOYRyyQX9TeOmdWiX8PlvVqIxAq4c8xqyJJmGxCHtsBLPMKjAgULFto2IWa
mAyOLjfd8ML21pqb0IvDWzfzjRZCrKc8SbVRPYdWxz4kP92U4LwdPS69x6ieSEPG
Xy1Gzo+aWkPGGZUN9GMm
=TYib
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_08_19_35_+1100_XRySf42qdbHnbFer--
