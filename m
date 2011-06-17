Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1FQVB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:01:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54526 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab1FQVBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:01:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] Add watchdog driver for Intel TunnelCreek
In-Reply-To: Your message of "Thu, 16 Jun 2011 13:05:50 +0200."
             <1308222350-21634-2-git-send-email-alexander.stein@systec-electronic.com>
From: Valdis.Kletnieks@vt.edu
References: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com>
            <1308222350-21634-2-git-send-email-alexander.stein@systec-electronic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308344475_3369P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Jun 2011 17:01:15 -0400
Message-ID: <36169.1308344475@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DFBC09D.007F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308344475_3369P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jun 2011 13:05:50 +0200, Alexander Stein said:
 
> +config INTEL_TUNNELCREEK_WATCHDOG
> +	tristate "Intel TunnelCreek watchdog"
> +	depends on WATCHDOG && PCI && X86
> +	select MFD_CORE
> +	select LPC_SCH
> +	---help---
> +	  Hardware driver for the watchdog timer built into the Intel
> +	  Tunnel Creek processor.

Please add part names here so we don't have to guess/remember what the now-retired
code name for a processor was.  Just because the guy who wrote the driver knows what
the development name was doesn't mean that the poor guy saying 'make oldconfig' knows
whether this is a driver he cares about.

http://www.engadget.com/2010/09/15/intel-retires-tunnel-creek-codename-debuts-e600-series-atom-sys/


--==_Exmh_1308344475_3369P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN+8CbcC3lWbTT17ARAg5kAKD5cWwGqbg7uGRk/ySJYh3yrqvaIQCeNvEU
ALbVxzfZpvWg/MgRLYR2x2g=
=8rO4
-----END PGP SIGNATURE-----

--==_Exmh_1308344475_3369P--

