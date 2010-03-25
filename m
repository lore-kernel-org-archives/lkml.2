Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0CYT6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:58:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42999 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0CYT6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:58:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Renninger <trenn@suse.de>
Cc: Borislav Petkov <bp@amd64.org>, akpm@linux-foundation.org,
       davej@redhat.com, linux@dominikbrodowski.net, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
In-Reply-To: Your message of "Thu, 25 Mar 2010 10:43:04 BST."
             <201003251043.04867.trenn@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <1269452783-966-1-git-send-email-bp@amd64.org> <1269452783-966-4-git-send-email-bp@amd64.org>
            <201003251043.04867.trenn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1269546919_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Mar 2010 15:55:19 -0400
Message-ID: <13218.1269546919@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=50/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=bulk(0),
	refid=str=0001.0A020207.4BAB7CCC.0035,ss=3,sh,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1269546919_3923P
Content-Type: text/plain; charset=us-ascii

On Thu, 25 Mar 2010 10:43:04 BST, Thomas Renninger said:

> > +	if (c->cpuid_level >= 6) {

> and remove this (arch/x86/kernel/cpu/intel.c):
>         if (c->cpuid_level > 6) {

So is > or >= the correct comparator here?


--==_Exmh_1269546919_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLq7+ncC3lWbTT17ARAs2wAKDSkpHMxdJJJ13kPZB6ZKA+tnJpRwCfaxvS
mzLWFuRWw/Ke4cFiiDHrJ/c=
=J2C6
-----END PGP SIGNATURE-----

--==_Exmh_1269546919_3923P--

