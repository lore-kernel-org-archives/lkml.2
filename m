Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2C0E5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:57:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42986 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2C0E5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:57:31 -0400
Date: Tue, 27 Mar 2012 15:57:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>, Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120327155717.b940b29403ec5d1c1fa54360@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_15_57_17_+1100_+kvb0dkst_JsrZvi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_15_57_17_+1100_+kvb0dkst_JsrZvi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kernel/process_64.c between commit 90e240142bd3 ("x86: Merge the
x86_32 and x86_64 cpu_idle() functions") from the tip tree and commit
54d16004d978 ("x86: use this_cpu_xxx to replace percpu_xxx funcs") from
the akpm tree.

The former moved the code to another file, so I did this change from the
latter (in enter_idle) to arch/x86/kernel/process.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Mar_2012_15_57_17_+1100_+kvb0dkst_JsrZvi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcUitAAoJEECxmPOUX5FEu5gP/1O5i0aK14AJmwzkzILxuI7P
KSRx38GLCBL6OR5AScySw591YeJVOZ8GOxITVx3v/rJZsUNcQhd9RBJieVHTwzKA
0mHjRjj/cx3mC44Jd8ekTBBF/X9PjOxOY6p31KYxkYGNbrruhT7eDHEc4QZAUccA
znUTWi6AGuiNfrTndxGR/7RGAQi62cZx6naoc9VuK8S1pCqv7ZBUZ7GB8xQ7/t7B
Tews8Tzyu8DdPmBF64VjY7epguX+3ccGGHYgzZr9ToY9e9K85e0iE64Sfh7s4D3y
hgahF0Z8d/Vwtkjq+m8Q2B2ZNCviltW+zqHTOmDsHDVXTZIUeli4f9ysMRVxtNSx
4HVYBPv2aVYOOFUvGpmjcKQ8hsKnmtVazw/UE7Y2Oy1Ede82Ywtt7fNYWRsUoab2
jn/55VQPdXbFvFUs07cjWwY+9vzoEOXLhXd1jGvnF4sS6b6N7q5eN64Rj3mCTRbH
mKd18Isdu0h7ULNvfKdE3zou9tNz4xkCK5TMchtLj5m729hMEmG+0O/bbwjvFTgd
e99UCW8HLh9iFLhcDlT6jqQfcA1FEoG6b8TTQlfyEjIyWaM1ZnQs0yGD9wp1CN5r
nhBmwWTOLAzGwqjfyC30eI1zVgaLwTcKYv7VlYA1bkZyM8H69xrZUROw0rVzs8Ph
jVCduy7onPOz1p1vs3s1
=ZUX8
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_15_57_17_+1100_+kvb0dkst_JsrZvi--
