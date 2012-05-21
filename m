Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2EUH76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:59:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58448 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2EUH75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:59:57 -0400
Date: Mon, 21 May 2012 17:59:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120521175945.fdd78de4fabf055db54f846d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_17_59_45_+1000_DeMnPHq+8+I05vZR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_17_59_45_+1000_DeMnPHq+8+I05vZR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kernel/trampoline.c between commit c9b77ccb52a5 ("x86, realmode:
Move ACPI wakeup to unified realmode code") from the tip tree and commit
"x86: print physical addresses consistently with other parts of kernel"
from the akpm tree.

The former removed (or moved) the code modified by the latter and removed
the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_17_59_45_+1000_DeMnPHq+8+I05vZR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPufXxAAoJEECxmPOUX5FEJD4P/jcAae/ZYQIy0jKBDYnDNNc5
4qkxdNpx9csYANgBNNwO4FOXbURNwTO1386wlUrsGp+RBk4Rr7aq/zm+Qg2rtksy
mV0mpueXKw68vnN8YBxGeT3rdJ1tfyq0BCEvnvtYSYHDTF1ntZTaU/I+AQwwiH+r
wOd8dEM42+a0YdfmJztUfSzDroYIikKbg7LlC2X93MZRE6CkobscZ1KTIk331ZIQ
2fa7aosUQkvaHlORjfUj9Hn5fktVVZtq1zVQMtKwRdctIrHeWhjo3S5IHpCES155
fqGLjdDwBOJ1vuTsc+c+xg468t0SzR8K7cEGaqOkqepZspSoPQKHOuMu6DZXvVDd
R3Xhn/29aK6+2NObOoE4XaZmQvQ3SWHCB4MhiG03uDrw2cfKOjDRwi6YTsVuBNiJ
Z5+AbHcOqp/qS9TPj+rEBG5B3qe5IGjAcLJxL9W0Q9kwikN4x3POn+YdG2cbznY9
A1XPp5c+3tpxJA/Z/+W4vVAuYfEL19v1rgD0Bns/rmpOAI+S8cMSKLf4FgOzSvLb
bT2tjO+uYPZ/tQD1Oav0jqoRr9C7OeLoMtj0SanydLM1GS2glKbnUJf0OcUdTXGv
kPJX7pYxwkubfSpk7CJDuM8S20AZ4wEPQn1Zgtaz0bF4f9bbz85GWGBhuDDfauZs
HKbAzdx9slKyfIkDOs1z
=Frjh
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_17_59_45_+1000_DeMnPHq+8+I05vZR--
