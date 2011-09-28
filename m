Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1I1VtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:49:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58549 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1I1VtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:49:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/24] C6X: New architecture
In-Reply-To: Your message of "Tue, 27 Sep 2011 16:29:41 EDT."
             <1317155405-26235-1-git-send-email-msalter@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317246541_2944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Sep 2011 17:49:01 -0400
Message-ID: <22021.1317246541@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E83964E.0042,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317246541_2944P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Sep 2011 16:29:41 EDT, Mark Salter said:

> This architecture supports members of the Texas Instruments family
> of C6x single and multicore DSPs. The multicore DSPs do not support
> cache coherancy, so are not suitable for SMP.

Is there a usage model for the multicore? I know somebody had some patches for
"HPC dedicated compute cores" that would just basically run a userspace process
and that's it - would those be applicable here?


--==_Exmh_1317246541_2944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOg5ZNcC3lWbTT17ARAvUNAKCQNKQ3GKe/pAXziry3frgqRubuOgCfXgzR
ea0cd5JWz6qrCamCTDAKsAQ=
=00bY
-----END PGP SIGNATURE-----

--==_Exmh_1317246541_2944P--

