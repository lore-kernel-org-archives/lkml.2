Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1I2McD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:32:03 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58919 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab1I2McA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:32:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Barry Song <Barry.Song@csr.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, frank.hofmann@tomtom.com,
        linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <baohua.song@csr.com>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_wait param to support MMC-like devices as resume file
In-Reply-To: Your message of "Thu, 29 Sep 2011 02:29:08 PDT."
             <1317288548-19560-1-git-send-email-Barry.Song@csr.com>
From: Valdis.Kletnieks@vt.edu
References: <1317288548-19560-1-git-send-email-Barry.Song@csr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317299401_4421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Sep 2011 08:30:01 -0400
Message-ID: <59872.1317299401@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E8464CF.010A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317299401_4421P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Sep 2011 02:29:08 PDT, Barry Song said:

> This patch adds resumewait kernel param just like rootwait so
> that we have enough time to wait mmc ready. The differene is
> here we wait for resume partition but rootwait waits for rootfs
> partition.

OK, seems a reasonable idea...

> kernel/power/hibernate.c |   16 ++++++++++++++++
> 1 files changed, 16 insertions(+), 0 deletions(-)

We have a __setup() parameter, this patch appears to be missing
a hunk for Documentation/kernel-parameters.txt?

Fix that issue, and you can stick this on there:

Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1317299401_4421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOhGTJcC3lWbTT17ARAjcbAJ9hqeFvA1FK4z3s4R/KevywFcmyKACgtGnI
QJpEBIgiSQbQUp+U16+tHfs=
=aeYo
-----END PGP SIGNATURE-----

--==_Exmh_1317299401_4421P--

