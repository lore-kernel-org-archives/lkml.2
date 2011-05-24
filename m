Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1EXCTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:19:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40733 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab1EXCTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:19:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, david.woodhouse@intel.com,
        akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, hpa@linux.intel.com, allen.m.kay@intel.com,
        suresh.b.siddha@intel.com, rajesh.sankaran@intel.com,
        asit.k.mallick@intel.com, kent.liu@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v3] x86, vt-d: enable x2apic opt out
In-Reply-To: Your message of "Mon, 23 May 2011 22:32:28 +0800."
             <1306161148-3987-1-git-send-email-youquan.song@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1306161148-3987-1-git-send-email-youquan.song@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306203521_3286P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 23 May 2011 22:18:41 -0400
Message-ID: <7457.1306203521@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DDB1586.009F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306203521_3286P
Content-Type: text/plain; charset=us-ascii

On Mon, 23 May 2011 22:32:28 +0800, Youquan Song said:

> +		no_x2apic_optout [Default Off]
> +			With this option BIOS x2APIC opt-out request will be
> +			ignored.

> +	else if (!x2apic_supported() && cpu_has_x2apic)
> +		WARN(1, "Your BIOS is broken and requested that x2apic be "
> +			"disabled.\n This will leave your machine vulnerable to"
> +			" irq-injection attacks\n"
> +			"Use 'intel_iommu=no_x2apic_optout' to override BIOS "
> +			"request\n");

If we're doing a WARN level here, what are the downsides of just automagically
forcing it rather than making them use a kernel parameter and reboot?  Will
some systems fail to boot because the BIOS was in fact right in requesting
hat x2apic be turned off?



--==_Exmh_1306203521_3286P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN2xWBcC3lWbTT17ARAp+GAJ9FjFYCOmOlc7V9myPA6yGodqjGBgCgmlf/
yjvcLCqL/0Q46YlNAqxyHBg=
=TURs
-----END PGP SIGNATURE-----

--==_Exmh_1306203521_3286P--

