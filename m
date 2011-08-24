Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HXBwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:52:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60002 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1HXBwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:52:43 -0400
Date: Wed, 24 Aug 2011 11:52:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-next@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: linux next: Native Linux KVM tool inclusion request
Message-Id: <20110824115233.4b515a6ceee8910e9c21fc50@canb.auug.org.au>
In-Reply-To: <1314044960.3668.9.camel@lappy>
References: <1314044960.3668.9.camel@lappy>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Aug_2011_11_52_33_+1000_u9E6S=mg5bVeu33K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Aug_2011_11_52_33_+1000_u9E6S=mg5bVeu33K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sasha,

On Mon, 22 Aug 2011 23:29:20 +0300 Sasha Levin <levinsasha928@gmail.com> wr=
ote:
>
> I would like to ask you to include the Native Linux KVM tool in the
> linux-next tree.
>=20
> The branch is named 'master' and is located in:
>=20
> 	git://github.com/penberg/linux-kvm.git

I have included your tree from today and called it "kvmtool". I have you
and Pekka currently listed as teh contacts (since it looks like it is his
tree on github).  Please consider adding a MAINTAINERS entry for this.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__24_Aug_2011_11_52_33_+1000_u9E6S=mg5bVeu33K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVFlhAAoJEDMEi1NhKgbsQzgH/RPUL1O4Md5lNjtBRg2XBVlZ
9cS2SalPjXXg1ZhKHAGlyQZNlGedm3v3+6FpytST6mF9D9aaxvv2jyFCg7mVAu7T
jCtRaQq7PYKPmmYR5DtQhyxp161UFrxU6DXiUKJx28S+eglnoLgU5xuSkjVw9S9u
5DlYpOGGlXtsfoV/gpq7NRRkWmaYj7vOvQtJjhf2Ojus1tDXbxk8uhARrG6dkZ5F
3Nndd3KUAgnFXir1e33FkRd1R4bGFswP71qlAdvXJKQrKnIOxijHGrepQzeHQ3+7
DWoV8Tp7vDCUoNri/2f2UYy5etRy9TG9CUT1zTIGJJaPDxrIUqNkQQTmQYIsliE=
=X5kn
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Aug_2011_11_52_33_+1000_u9E6S=mg5bVeu33K--
