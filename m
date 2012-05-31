Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2EaIZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:25:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46909 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab2EaIZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:25:13 -0400
Date: Thu, 31 May 2012 18:24:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120531182451.ad63c2bf993ce2f5400896a0@canb.auug.org.au>
In-Reply-To: <20120531072505.GA1371@cmpxchg.org>
References: <20120531141329.6f82889bcfaa30ca83a30937@canb.auug.org.au>
	<20120531072505.GA1371@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_18_24_51_+1000_Eby4P2VbhNZzOIol"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_18_24_51_+1000_Eby4P2VbhNZzOIol
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Thu, 31 May 2012 09:25:05 +0200 Johannes Weiner <hannes@cmpxchg.org> wro=
te:
>
> On Thu, May 31, 2012 at 02:13:29PM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the akpm tree got a conflict in
> > mm/memcontrol.c between commit 78ccf5b5ab83 ("mm: memcg: print statisti=
cs
> > directly to seq_file") and others from Linus' tree and commit "memcg: a=
dd
> > mlock statistic in memory.stat" from the akpm tree.
> >=20
> > I just dropped the akpm patch for now.
>=20
> Thanks, Stephen.
>=20
> However, the patch is known to be broken and, according to mm-commits,
> was removed from -mm on May 16 already.  How'd it reappear?

Andrew only send me a new set of patches at irregular intervals, in this
case the last set arrived on May 10/11.  I just keep rebasing the patches
until Andrew sends me a new set (Andrew: big hint :-)).

I will remove that patch tomorrow in any case.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_May_2012_18_24_51_+1000_Eby4P2VbhNZzOIol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxyrTAAoJEECxmPOUX5FEYkkP/AlRVMYJlIoJLe9aZ46uP3+H
eWC5hhgPo8zWE8Vit1S1KbSExP9ngI4DZ08cXE05Qu8QA9DctI+DjNm64IAimJEI
8pLimV5+yL2bRSXUQX2Hfo3A5Z/AGCrYxFSR3DXx/MGgOODkkrxW1bNBnqWPNNds
3stvBUzLAQjv+zfk7QrGr/1X2jmxKV/6wraUn/jXrR7qdGeWO/S+2E/coULxyFrC
/MowmY5e0Q/7LCGxYVr16vasKxhOGqZFw+EM66TZuZ4x1Cn8WpIyFUtw1m1JYrqb
bklaloNAKLawLo9qCulXKqiOl6DycGA4mnXEK1H1LcyyMAQH04kYQOMHmbLHlj0f
V58eQ02XBh4xIxUrWg9r+pBkT712a/c2tKiZAfbSq2Bur9Nus8b2wCiOTmaoJd3+
9usvFqJF1YQab3ZNvFbAc2FU5MVkhgCRPGl3c87yCVdiliYGqoxDoXgJx6rt+yWD
QvUgz1QoQqipdHq5YmD/YLrGqEyYM8ivclBvNrMcSt3JRTGD+Wg+DfcqC7iKhbKe
1wbcY90/uQQLa/MYk1DuG9c/2mTAY2iC6+AAJ4AwH09qOFIMXqgWV0eTyRdhQ/sF
PRPr3aVN4Fr0tJQDIG+8YE4wTHI6t3zV5z2rRBL17mpBztMof9EgFGrThpPCVsCg
npq2BmdMSQUiQV+jWA3p
=LCfF
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_18_24_51_+1000_Eby4P2VbhNZzOIol--
