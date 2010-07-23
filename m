Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0GWLmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:42:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39685 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0GWLmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:42:42 -0400
Date: Fri, 23 Jul 2010 21:42:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Message-Id: <20100723214233.7cb7de8d.sfr@canb.auug.org.au>
In-Reply-To: <4C497E5F.80301@kernel.org>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>
	<4C497CD5.5010908@kernel.org>
	<20100723213148.3d2193a3.sfr@canb.auug.org.au>
	<4C497E5F.80301@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_21_42_33_+1000_Bfs_+g.DEzoSN.Zv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_21_42_33_+1000_Bfs_+g.DEzoSN.Zv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Fri, 23 Jul 2010 13:34:55 +0200 Tejun Heo <tj@kernel.org> wrote:
>
> I was thinking about sending pull request w/ a note describing how to
> resolve the conflict.  Would pulling in master before requesting pull
> be better?

Either would work.  Linus is fine with doing merge fixups and, after all,
I figured it out. :-)

A description always helps, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Jul_2010_21_42_33_+1000_Bfs_+g.DEzoSN.Zv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSYApAAoJEDMEi1NhKgbsrNAIAKABrlLhgfKzwt+RO0EjIKIr
5jdp9Ym9UP9VGsLg4rXXZ2zK3E4yNGUR1uEOBqwgr42g5KKlpYyK+KmtQ8y/M//2
nDVJOBaLud1M+6sPOE0g6Dux/wOJah4LN0lcKSEzXrj/7BRnlFPj1GAfA7tM5fz4
OZF8HkpDNknpOILJw1wrgoqahZlCInW/DtL6N8jMnMKXwGtijgpftBjWmrVTh17k
U3lyUKmSyl2GCXe/jgKjBA5ACdJscMDCpAVSCJKDaiJaBtoq94eiMpEyWxtM31Nu
fu1OFREnSEyW5q5DcSpdvFU+8iwKVOuHHh1Oo5eTSSSp0lmkUCUEfjL3PiJcO60=
=iGt2
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_21_42_33_+1000_Bfs_+g.DEzoSN.Zv--
