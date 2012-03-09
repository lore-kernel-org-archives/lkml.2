Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2CIElK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:41:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2CIElI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:41:08 -0500
Date: Fri, 9 Mar 2012 15:40:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the tip tree with the powerpc tree
Message-Id: <20120309154050.6c7921999366c42cd1d15446@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_15_40_50_+1100_k_kpnCoKBhx6fCBX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_15_40_50_+1100_k_kpnCoKBhx6fCBX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/powerpc/platforms/iseries/setup.c between commit 8ee3e0d69623
("powerpc: Remove the main legacy iSerie platform code") from the powerpc
tree and commit bd2f55361f18 ("sched/rt: Use schedule_preempt_disabled()")
from the tip tree.

The former removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Mar_2012_15_40_50_+1100_k_kpnCoKBhx6fCBX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWYnSAAoJEECxmPOUX5FEQEUP/0FpHjy6Wsr79Vu38PHSw72N
iqZSobTXGyprfZePCBWKP6/+kcVSPYvoz0+yJVqA1XPI7U4evJqlmnt82+ujK28a
W1XbOzPCp82OLpVyR7llJ98+TXF8nzV8brG5ZUekOnYN9K5mGE2B5K5paETd+eVu
6+9ThpZAClNW/U/nV/c48Hno1/jWQ9wCDSMAtayli9sNMLzVkO2GK4+uar4khnzI
Q5iU6hyZfjYi9QnPse8XsBxOgJeSwyIgSYF3h8au9ue2Dhti3rlBj/83lNAa7lZ9
+Z40l7373a6/M3RSoY7BYNAZc4qjjwiBggV8whfcrPSn2Y46HCF3p84L4NfV/sEP
7NIAxUSOtsNFh4M6alTaWAe5iqSb9nBajnFb/ymDlB5bNyZIjElJVuRxMFpkvtAj
1aYhXa0V0VLXeEQJDOaDB5s3lFZcnPRsIEMCIS1QZLccBkwjEL7Nbdui+FmvCPFm
xzN08h3xK3l7SlGDqMQ30wtptnIQpHdJQMfnQKVXmMacINK+BOyaicMM6r6lZTUX
Ixaey5nh4b0wb7DuqU09ZW41f5E/u/VglroeIXM2PBzSoqFbbwQW3jfl1ETxU9KG
AYYp6x87FJTkJPP8CKi2YrJd8jNrJAx27irpWcwC7ExfXLqChI/sHSzOPsZ4m0SN
BbU+uZv9eLg90SGaZK+a
=UZMA
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_15_40_50_+1100_k_kpnCoKBhx6fCBX--
