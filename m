Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1LNHQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:16:01 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43788 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LNHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:15:55 -0500
Date: Wed, 14 Dec 2011 18:15:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build warnings after merge of the final tree
Message-Id: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_18_15_45_+1100_z=aM626Qcy4N7LZu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_18_15_45_+1100_z=aM626Qcy4N7LZu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
produced these warnings:

In file included from arch/powerpc/include/asm/asm-offsets.h:1:0,
                 from kernel/trace/trace_syscalls.c:9:
include/generated/asm-offsets.h:15:0: warning: "NMI_MASK" redefined [enable=
d by default]
include/linux/hardirq.h:56:0: note: this is the location of the previous de=
finition
include/generated/asm-offsets.h:128:0: warning: "CLONE_VM" redefined [enabl=
ed by default]
include/linux/sched.h:8:0: note: this is the location of the previous defin=
ition
include/generated/asm-offsets.h:129:0: warning: "CLONE_UNTRACED" redefined =
[enabled by default]
include/linux/sched.h:22:0: note: this is the location of the previous defi=
nition
include/generated/asm-offsets.h:165:0: warning: "NSEC_PER_SEC" redefined [e=
nabled by default]
include/linux/time.h:40:0: note: this is the location of the previous defin=
ition
include/generated/asm-offsets.h:173:0: warning: "PGD_TABLE_SIZE" redefined =
[enabled by default]
arch/powerpc/include/asm/pgtable-ppc64-4k.h:17:0: note: this is the locatio=
n of the previous definition

Maybe caused by commit d5e553d6e0a4 ("trace: Include <asm/asm-offsets.h>
in trace_syscalls.c") from the tip tree.  These warnings may have been
here for a while as it is hard to catch the new ones among the flood.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Dec_2011_18_15_45_+1100_z=aM626Qcy4N7LZu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6E0hAAoJEECxmPOUX5FEnkAP/iHiiKvfQ0joG7yEwNgWBjR6
Kx2ExnHdY7wPap1wl8BnhrjqGuQCBl3J3EBy2m1I0uj/0eKR+ChGJZnvrmrnhsmn
r6S24vHCKl9YUimVf8buVFVMN0Vh6i0dEv3fFPaHHg8klhcN7aDud5d33oa+o1ai
gtfdjBxRPSZ0WIBLXWGfK/lN1LKWj14spdNTVvm/IfppD97CD4TBwX0AVm8VpDRz
Odn3jo5tbL2JqxGP0SxidkSlmC6S//hkUqQINl2lDYiO8yWwfw4xnJtEeI8nRssp
yxhzY5sptrulvTvG01AnTZ4rsiIAvBKcby+PdfSA9yEi/GW2aARcOZWVjnnRjnt3
0J3EXoUALIoECnQgOedMatpW0nWy+ev0H2gGVnkezoQ6G5o/Ctk6sXKVs6HMi6cD
FodFVYXjuiGCiZzwEtB7wcjaxgOsS534hTnQkOE3f7YqPIuEMHBZF/AzyOyUrbN7
5K6IhmvItelrTK/gFt2Rtlywh4i8O74CnFEZpOZEmm7+WVO6eWQrGPL5UAfP+wj8
hPt8NYwOo8zAohHnkuSXiTc90yEAPNcWPgRkWy0tLBxjrpyo5cyjZHvt7gLE9Pw9
1fwHlatou7nf4lZLh6/zTBygqwuTQqgf8ApeBX9C2J8IG3+19yiGFi9KhOxFIWA4
rTxCzx3yOgyiq2bqCp49
=i+tg
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_18_15_45_+1100_z=aM626Qcy4N7LZu--
