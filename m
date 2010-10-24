Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab0JXX2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 19:28:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59396 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0JXX2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 19:28:44 -0400
Date: Mon, 25 Oct 2010 10:28:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.37 merge window
Message-Id: <20101025102833.a8f7f252.sfr@canb.auug.org.au>
In-Reply-To: <4CC434A8.1000903@redhat.com>
References: <4CC434A8.1000903@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_10_28_33_+1100_eMUJSf_QNyNyFHei"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_10_28_33_+1100_eMUJSf_QNyNyFHei
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

On Sun, 24 Oct 2010 15:29:12 +0200 Avi Kivity <avi@redhat.com> wrote:
>
>   Linus, the repository and branch
>=20
>    git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37
>=20
> contains the kvm updates for the 2.6.37 merge window.  Major changes=20
> this time around include powerpc paravirtualization, a virtual tsc=20
> rework, and exposing npt to the guest for fast nested virtualization. =20
> Please pull.

This entire branch was rebased just 11 hours or so before being merged
and you have "talked" about this for many merge windows that I can
remember.  "Just saying" :-)

[Avi, I am not particularly picking on you, your tree just happened to
strike me this morning ... there are many others.  At least you also
updated your linux-next branch so I won't have to cope with two slightly
different versions and all the conflicts that causes :-)]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_10_28_33_+1100_eMUJSf_QNyNyFHei
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxMEhAAoJEDMEi1NhKgbs1mwH/12wLk/HzFiDdoVOXS9S0JPq
rUbJ8akQSqy4OrMqdI+D1k4vn8/LsBKIKAzkKThv7n6WpW6QKZNamGwwRLmDLrao
1Ay+HN4V1fMViomVOLK/OohcjkXDAGXFCfVvbN8+oRqVahxgt2Uz7qhIzG38XgGw
kb1929B6tQ3HyBc84NkW8mp+QxiDn5vPLwN0uJU5omrfq/IxBpeZfBcueo+z5y/7
uNske91yVvUaeGbOIVV63AEpKbbppo1JqZnU4cYqlHiZ+EvFxzUProHLr5vqGn7D
YZ/FU9cglu/L/4b13cYOPkW+nwb3Wp9iGs2ch9evXcqfUHvvZ2joXC2QmNupb5Q=
=WZiJ
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_10_28_33_+1100_eMUJSf_QNyNyFHei--
