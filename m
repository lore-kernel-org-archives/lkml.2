Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0LJCc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:32:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34530 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab0LJCcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:32:25 -0500
Date: Fri, 10 Dec 2010 13:32:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20101210133212.70844480.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Dec_2010_13_32_12_+1100_BTN0ABnOX/zD_Ra2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Dec_2010_13_32_12_+1100_BTN0ABnOX/zD_Ra2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/x86/kernel/apic/nmi.c between commit
5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a ("x86, nmi_watchdog: Remove the
old nmi_watchdog") from the tip tree and commits
aa0be2afeed15edd653830ca87a3f173f08c23e6 ("x86: Use this_cpu_ops to
optimize code") and e5195e91d9b579ba9def00ea2e8b96189c0120f4 ("x86: Use
this_cpu_inc_return for nmi counter") from the percpu tree.

I just ignored the percpu changes to this file and removed it as the tip
tree did.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Dec_2010_13_32_12_+1100_BTN0ABnOX/zD_Ra2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNAZEsAAoJEDMEi1NhKgbsLhEH+wf+sdTAV189A1M3ZJCmhk4E
jIrDGBNofKcHMRd2tCHgkTPtxLj9sV6F7PDSo/k5MuwPQl0ni4ARHUvywqFOP44A
11A1I3cB6WoJo5Os2fe8T2X9pxQiIzmZvskp+sRx9yPMd5C1qj4pe923OZ9/sqYW
aqd+bSxVBsjeXzuTphVIxVQ1EcNfWRtgG6IyZckGbDb6qS1rQvCh1tU6iSPmHC7B
0OFsq3IdtiqDCZ1oNJZ65CljAUXC8DRipx6RalG1v/fR/aCv3CWnRsz02OkWU6bg
/YaDnBTyeQKq7K8SxyxsgzW9hv9L0zQlldEMi3d/D4i9x9NMUD5Im8ZrMmHe5ZM=
=3Xu3
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Dec_2010_13_32_12_+1100_BTN0ABnOX/zD_Ra2--
