Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657Ab2KIDnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:43:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45463 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab2KIDnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:43:09 -0500
Date: Fri, 9 Nov 2012 14:43:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20121109144307.a2a77fcdab8aaa262bf54cd9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_14_43_07_+1100_h2IJ8LbDnL0NJVsl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_14_43_07_+1100_h2IJ8LbDnL0NJVsl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
allnoconfig - among others) produced this warning:

drivers/of/fdt.c: In function 'of_scan_flat_dt':
drivers/of/fdt.c:490:10: warning: assignment discards 'const' qualifier fro=
m pointer target type [enabled by default]

Introduced by commit "drivers/of/fdt.c: re-use kernel's kbasename()".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Nov_2012_14_43_07_+1100_h2IJ8LbDnL0NJVsl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnHvLAAoJEECxmPOUX5FEcA8P/jwnQ0BPgRf6LFDncHqgXT4W
AHP8hPBDBth8gDk94y0MeuWMqKsWtvsoI5ZUL0rMYFIKiwqN/Pu/D0SWoqHyvhS8
qtR8PVTN+fpsjl85UE+Qr8IY39Wk7A5OVF7FJO2ovAevMEdF6qnwfsDZZWJPscty
Dp6bCTa8lUblitX92XAWLXOQ5vTJfGdwmn3KIRPaTmbDTfVyz+GlsVJgtKL1LlB6
5V5nNk7iC2M5IhR4R9FBANmNkSIGdcrJs/61BavQbnbDxciLmjgTHJyD/ZvEWtRV
xrfuRIGfBBCxCN7zJiqfvkiFtF4flJ53EKvyhVXBpLXQgfIA0LVuMU+35oPPlP6T
Mb/7GaTLab9gt/d80gSIN14NffuAiGd/XzZ7MH2lFi5+OPCAtJ+VQFq2uRvsc4Wp
f/HjXob13O3V9nffPKdd6wTF1ab3WBOGxJrRiASLNmYsSpKs3FmS5fD4rwGhyegp
vebYhNAMjLszHehu454pK3yUQj47I+ljV9cvTa4wdaBeB9jK1YIhw4I2LHeFjuxA
pVnkEnm+H2Rqco2veApeAQEDlOtG1TKeRFuJB0yFHWqPU+yBPs9pEWjNb5mHGa3w
GOBRQSCEK5b7tvhIDllW5vHL0ip5gkj1Nd0TKmrvWrJw67+zMEf8/CPNlZjQCHtM
40TcLkL+9+RCNq+/9T8y
=4AtW
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_14_43_07_+1100_h2IJ8LbDnL0NJVsl--
