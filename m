Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab2JLCNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:13:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49933 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2JLCNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:13:00 -0400
Date: Fri, 12 Oct 2012 13:12:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the kvm-ppc tree with the kvm tree
Message-Id: <20121012131249.f86c7519ea8b07c67ae9f6e4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_13_12_49_+1100_Nugc_XI=NktqRx30"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_13_12_49_+1100_Nugc_XI=NktqRx30
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
arch/powerpc/kvm/44x_emulate.c between commits from the kvm tree and
the same patches plus another commit from the kvm-ppc tree.

I just used the kvm-ppc tree version.

This happened because
	1) you rebased/rewrote your tree before it was merged into the kvm tree
	2) left the old version in your kvm-ppc-next branch
	3) added some more commits to your kvm-ppc-next branch

Don't do that!

Unfortunately, the best thing you can do now is to rebase your
kvm-ppc-next branch on top of the kvm tree.  :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_13_12_49_+1100_Nugc_XI=NktqRx30
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd3yhAAoJEECxmPOUX5FEBRwP/2Fu/fP9wNOjJvjDiQ6s/hTf
H9zjZA8/tbdjPuTOiuSg4HZfxzBWqGn9YZwkMweRY4YmQH9D3JtWOVinABk8vrke
JYm8TU/Z+DUGrLvqWd5BLezbbLiP798b+EJOZz36JinP+fStn3FK8WFSWGX2i6wq
ejC0tYJ9R/naoWh+p/oSUtyRKkHP38okE4MbrviyjzcKxJTpLD1gAr7iOUlWYf9Y
OY6Sy+XuC5FfTqyJ4VeEG/jzSTBa3cjctm6wJamKTFLqNyFQk6G2qVoyG8+wNFeT
qgeMxJIoUGeM6k4SK/E8h/jfRcI/vDrGfLOSn7W63F2fFkkayJeEQraW56P+chq1
DkMj5KJyENsS083EvOA5+qxK8osrtlZAF9F0vW4PY1lnN44+MlFG1N1hKKacFBom
oRYpOBqIR0iDrjlO0wNXp1WS5aHPp7Fba5sUZCXcFcdOZWts/xVbew01na0cCk0r
q/BpD3gn85u10T4R4AZSUnLngiz8hIWPt6vQPfoIeVqUCjuQj65XeXYcWHHkBmrS
/9CDiMBpk6oSqYRIWjKzTfBGc5iYnAB1TESWYNuo1ZS5pknaQYLIZIVa2tDijTrR
8XgFn7EXTuH71HhNKrhxZNpAuXot7/bl4E/x/fVzCT5JfGEKAiQ6TiHXMUWoa+Pg
Fx++dpJG7+v8AZcXqrNd
=L0nr
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_13_12_49_+1100_Nugc_XI=NktqRx30--
