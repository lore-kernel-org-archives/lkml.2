Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1GEXde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 19:33:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35912 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1GEXdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 19:33:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-mm@kvack.org, svaidy@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mm,debug: VM framework to capture memory reference pattern
In-Reply-To: Your message of "Tue, 05 Jul 2011 13:52:34 +0530."
             <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1309908804_18528P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 19:33:24 -0400
Message-ID: <64797.1309908804@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E139F47.002E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1309908804_18528P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Jul 2011 13:52:34 +0530, Ankita Garg said:

> by default) and scans through all pages of the specified tasks (including
> children/threads) running in the system. If the hardware reference bit in the
> page table is set, then the page is marked as accessed over the last sampling
> interval and the reference bit is cleared.

Does that cause any issues for other code in the mm subsystem that was
expecting to use the reference bit for something useful? (Similarly, if other
code in mm turns that bit *off* for its own reasons, does your code still
produce useful results?)

--==_Exmh_1309908804_18528P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOE59EcC3lWbTT17ARAgICAJ0eK8nvfFWBX/my5unboxcW+kwR1wCfe09X
iuBPwUv3052e06A6+wQsgOk=
=/A6K
-----END PGP SIGNATURE-----

--==_Exmh_1309908804_18528P--

