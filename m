Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0JRCUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:20:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37070 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab0JRCUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:20:44 -0400
Date: Mon, 18 Oct 2010 13:20:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: build failure after merge of the pci tree
Message-Id: <20101018132035.c506beff.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_13_20_35_+1100_AQt/+2pjJahigIjU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_13_20_35_+1100_AQt/+2pjJahigIjU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/pci/hotplug/pciehp_core.c: In function 'pcied_init':
drivers/pci/hotplug/pciehp_core.c:348: error: implicit declaration of funct=
ion 'alloc_ordered_workqueue'

That function is not declared anywhere except the (yet to be merged)
workqueues tree.

I have used the pci tree from next-20101015 for today.

Please build test what you are exporting for merging into linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_13_20_35_+1100_AQt/+2pjJahigIjU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu67zAAoJEDMEi1NhKgbseDQH/jz9883mp9hgFBGwjuaeS9IL
kFIocjjMPqfxGQxn3iH8CB+GrbeOb8q81Bv8o04iWbODItHyMCwGawiJPjfd/fzG
wbQQU1F89PU1zVnIco7Ni8GQN/MdwHaHlAl5d7NTZNpLr6ge5fiLIGPXNuBnYWpV
eEtxL204k9XQ4Ud0n0GpZL4LMgV6+QU5mLYESAhNLnvt2HiH1/z6HtdWdZMjcUR0
KbTrUUU7E5FIJBqMIAJscDLOkuLoEbr36g2cXfhFH/tXfsptChqZNqHsslcsGlj5
k9kWZgvhKAWDpjgjg7FCvHlRJ4rnLuzQcDkciLeEbXP3xvCKZEW2+dhmRqcecBE=
=LOda
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_13_20_35_+1100_AQt/+2pjJahigIjU--
