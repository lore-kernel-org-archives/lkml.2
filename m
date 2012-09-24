Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2IXX6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:58:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2IXX6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:58:04 -0400
Date: Tue, 25 Sep 2012 09:57:55 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] block: export trace_block_unplug
Message-ID: <20120925095755.048903e8@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WyFDM00HCpxZiuQMyVpwswK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WyFDM00HCpxZiuQMyVpwswK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Jens,
 is there any chance this can be in the next merge window?  I'm
adding block tracing to md and found I need another export.

Thanks,
NeilBrown


This allows stacked devices (like md/raid5) to provide blktrace
tracing, including unplug events.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..ef55ae0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -40,6 +40,7 @@
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
=20
 DEFINE_IDA(blk_queue_ida);
=20

--Sig_/WyFDM00HCpxZiuQMyVpwswK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGDzgznsnt1WYoG5AQKeSBAApDDlSFsbgIEdVXJRzUPV7n8IV9eRCMYx
h3Z5aKGk1tAun+yWPCdPVLdgmfrCfGZzu+e2tg7qc2zbzziuyLlcMgpece/riCGx
PX6W5OiRyhfpgspndf5nvP7RQaA+7NB3ZT42aWBmMV4bIvTXTN/qwZkxn3eqKUA4
t+gDf+0Fndn+NWN8npDivZ4S9OobWIdt1rKHMh12b1hODVlyKI1vfP/wtIPhY0+O
L9V7N9C4Tv20wzTgMzoFKv1hZTGbUd7tflDoNXIKGU2nxb4Tw2rIQDUnOMGdG81K
fc/9s53/gHCGuv4ZXPKV94/zKV5Su8iiY3nWuyz1IrABRQIEq24hgljxoeO7wlWs
CTQuRAW8uzo9h/J8509fvFcQgpExmorhiNmBGJnUqmgwbGCFW43SSlw8iHG9SUpo
BRBK7aIpwEjzxN2vZaAHw6VgiGZfR9y6yEMKBBeMorWvmxQRmuL20+m5ztJFDFno
6KZOE+D9RKZyb0Tva3hs9qJLQm+43rI+EseqVu/3QbhIdMH2DItCLJ90U7VaMBFy
ctVGX2F4qWhGTnzejy1D8fICSdUxDMOLBYcfGUY1hDJyqgcxVxGlqgYwGFZ4Pfet
lFT2H76srbZ+fiCaV0O4Q2ETrdWh4p+bOj3cI54wC94wS03gEJQlomoS8a1N580v
/TxA1gibLL8=
=7a1E
-----END PGP SIGNATURE-----

--Sig_/WyFDM00HCpxZiuQMyVpwswK--
