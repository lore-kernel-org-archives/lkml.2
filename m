Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1GEWew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:34:52 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60095 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1GEWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:34:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
In-Reply-To: Your message of "Mon, 04 Jul 2011 15:39:23 +0200."
             <20110704153923.b929ce5d.taeuber@bbaw.de>
From: Valdis.Kletnieks@vt.edu
References: <20110606095127.21d23a70.taeuber@bbaw.de> <201106060559.03131.gene.heskett@gmail.com> <20110606130628.e86f0c67.taeuber@bbaw.de> <201106060920.32257.gene.heskett@gmail.com> <20110606155610.69a0d17a.taeuber@bbaw.de> <20110607124354.06ed074e.taeuber@bbaw.de> <20110701102323.3db579ad.taeuber@bbaw.de> <20110701151313.2afd48e0.taeuber@bbaw.de> <20110701163719.27afc580.taeuber@bbaw.de>
            <20110704153923.b929ce5d.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1309905287_18528P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 18:34:47 -0400
Message-ID: <62378.1309905287@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E139188.00B9,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1309905287_18528P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Jul 2011 15:39:23 +0200, Lars =?UTF-8?B?VMOkdWJlcg==?= said:

> 1.
> * Ultrastar 7K3000 attached to onboard AMD_AHCI
> * dd if=/dev/zero of=/dev/sde
> * dd told write speed of: 15.7MB/s
> * no error after half an hour
> 
> 2.
> * Ultrastar 7K3000 attached to PCIe to sata_mv controller
> * dd if=/dev/zero of=/dev/sda
> * dd told write speed of: 6.5MB/s
> * no error but strange log: dmesg-PCIe-sata_mv.log.gz
> 
> 3.
> * Ultrastar 7K3000 attached to PCIe areca SAS HBA (mvsas)
> * dd if=/dev/zero of=/dev/sdg
> * dd told write speed of: 1.3MB/s
> * errors: dmesg-PCIe-mvsas.log.gz

Umm.. was this the *same* Ulstrastar disk connected 3 different ways?  And how
exactly was it connected in each case? (Trying to rule out flaky disks if it
was 3 different disks, or a hardware/cabling issue specific to the areca
controller)


--==_Exmh_1309905287_18528P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOE5GHcC3lWbTT17ARAuOLAKDEkF1Q1fyJ4qRSMCpfOiDYatWQUgCfRuQM
mLAIxwua9yoai+50cwpuk8A=
=RZz+
-----END PGP SIGNATURE-----

--==_Exmh_1309905287_18528P--

