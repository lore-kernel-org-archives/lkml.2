Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab1AMPqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:46:24 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:59034 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1AMPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:46:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, linux-perf-users@vger.kernel.org,
        mingo@elte.hu, arjan@linux.intel.com, j-pihet@ti.com,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/9] cpuidle: Introduce .abbr (abbrevation) for cpuidle states
In-Reply-To: Your message of "Wed, 12 Jan 2011 17:25:12 EST."
             <alpine.LFD.2.02.1101121705130.19754@x980>
From: Valdis.Kletnieks@vt.edu
References: <1294396190-23031-1-git-send-email-trenn@suse.de> <1294396190-23031-5-git-send-email-trenn@suse.de> <alpine.LFD.2.02.1101120150570.19140@x980> <201101121437.51122.trenn@suse.de>
            <alpine.LFD.2.02.1101121705130.19754@x980>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294933349_5688P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Jan 2011 10:42:29 -0500
Message-ID: <13258.1294933349@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4D2F1D67.0229,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294933349_5688P
Content-Type: text/plain; charset=us-ascii

On Wed, 12 Jan 2011 17:25:12 EST, Len Brown said:

> > But by sysfs convention a separate file must be used
> > if two data are passed to userspace which is the case here.
> 
> what two data?
> 
> It is fine for a string to include space characters.

I think Thomas is concerned that although when you actually read a /sys
file, you know it's one string, that fact can get easily lost and cause issues
down the road. Consider this code:

foo=`cat /sys/some/file`
bar=`cat /sys/other/file`
baz=`cat /sys/third/file`
echo $foo $bar $baz | awk '{print $2 $3}'

Suddenly your output isn't what you expected...

--==_Exmh_1294933349_5688P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNLx1lcC3lWbTT17ARAh+5AKDO3njvfdeLwHRolBhga5tdWk17GQCfQjna
5NRZO5tAIu4zmvbxJ2zLUe4=
=B2BS
-----END PGP SIGNATURE-----

--==_Exmh_1294933349_5688P--

