Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1EXESi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:18:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45711 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1EXESh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:18:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, hpa@linux.intel.com,
        allen.m.kay@intel.com, suresh.b.siddha@intel.com,
        rajesh.sankaran@intel.com, asit.k.mallick@intel.com,
        kent.liu@intel.com
Subject: Re: [PATCH v3] x86, vt-d: enable x2apic opt out
In-Reply-To: Your message of "Tue, 24 May 2011 11:36:14 EDT."
             <20110524153614.GA19080@linux-youquan.bj.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1306161148-3987-1-git-send-email-youquan.song@intel.com> <7457.1306203521@localhost>
            <20110524153614.GA19080@linux-youquan.bj.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306210686_3286P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 24 May 2011 00:18:06 -0400
Message-ID: <17321.1306210686@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DDB3183.000B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306210686_3286P
Content-Type: text/plain; charset=us-ascii

On Tue, 24 May 2011 11:36:14 EDT, Youquan Song said:
> > If we're doing a WARN level here, what are the downsides of just automagically
> > forcing it rather than making them use a kernel parameter and reboot?  
> 
> As we have discussed before, x2apci opt out feature is requested from OEM that
> they want to firmware tell OS to opt out x2apic when the platform,
> hardware or BIOS is not ready to support x2apic. So we can not reboot or
> force to use kernel parameter.  

Do we want an actual WARN there, complete with stack traceback and all?

Or did you intend a pr_warn or printk(KERN_WARNING or similar?

--==_Exmh_1306210686_3286P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN2zF+cC3lWbTT17ARAmK/AKCfC6rW/mLzjXjryq8SJTosI676qACgoTXH
UCCmKKsiTkLYrgvJlGVQ/PA=
=xICR
-----END PGP SIGNATURE-----

--==_Exmh_1306210686_3286P--

