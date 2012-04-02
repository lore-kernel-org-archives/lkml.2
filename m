Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2DBX6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:58:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37896 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2DBX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:58:09 -0400
Date: Tue, 3 Apr 2012 09:57:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mundt <lethal@linux-sh.org>, <dhowells@redhat.com>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [PATCH 07/11] sh: fix several build failures from system.h
 fallout
Message-Id: <20120403095754.a70f38eb70766580843debc7@canb.auug.org.au>
In-Reply-To: <4F79ECD9.6000108@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
	<1333312727-11428-8-git-send-email-paul.gortmaker@windriver.com>
	<20120402010048.GA21647@linux-sh.org>
	<4F79ECD9.6000108@windriver.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Apr_2012_09_57_54_+1000_7YwivoXNtPZ2HaJV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Apr_2012_09_57_54_+1000_7YwivoXNtPZ2HaJV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Apr 2012 14:15:53 -0400 Paul Gortmaker <paul.gortmaker@windriver.=
com> wrote:
>
> On 12-04-01 09:00 PM, Paul Mundt wrote:
>
> > There's still more, but they've alreadly all been fixed up in my tree.
>=20
> OK, I can drop this one.  Is that tree part of linux-next?

I used to have sh-current and sh trees (and rmobile-current and rmobile)
trees in linux-next, but they have not been resurrected since the
kernel.org problems last year ...

They were all branches of
git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git which is
still listed in MAINTAINERS but does not exist :-(

Paul M, to you have an alternate place I can fetch from?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Apr_2012_09_57_54_+1000_7YwivoXNtPZ2HaJV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPej0CAAoJEECxmPOUX5FEN1YP/j/nNDBlh9ocYsMXC/KSTGQv
xbsKzFEuiEFOlFUND6hZeOpPpd+74fdBkD/hodEta9NMjmzdwJiL93k6Ptyz5D6x
aykQ/PW/WEtUuECV6V4Q/b/W73BrYZMSJHBFWuofONK2a1/0zlIZ9eRnG9rvCvvN
QHvwdGgX2I85jdU4FVLYc8aBS+uVRCoD7asa2/EJWo5NnhwPw1Sm1iSX4iJrJUJ8
++LqUXEYepzvneGP0ET8JxeZd/eH+F1AVwSjp2eZu2PekVIL+lcA2pxqPaCCpKnS
LyE4fddh64iHa34CXwwaFLA0YSXM1aE+VSa2irq1Cbl5WlOXhPzPZ7N6Mavd2Mi5
4Y0oQM6PwS2Mxr52V5VhnfUwNCMksZvq3x0S5i1ch7n09RNneocHSK8zF2i1PQ5y
Y5K9kv6G6J7FK8+vReBipr9B5JjmNn/WI1pe0X7ypBk6F8QAXGFhUH3RRpxETNCw
xDTYngGjeaqKAen8ZScaQ3yeo9+YrBiDWMr6w/5N9LKIeawAo2dZv7wu59KnaZLA
7RBIyd01Ih2a+QMl+bf2Of1RF5/YydLWngpabSRmT448XClGYSQHMRjVb/7ERJg7
t68882KaGfTUMAmpQefSV5I6AVSBblL2hpyxI752BEoj6RPItrdDKduA2d3AWGc/
1peos+tYZGcAgqHVinQ9
=bDA1
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Apr_2012_09_57_54_+1000_7YwivoXNtPZ2HaJV--
