Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1EXMOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:14:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41959 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab1EXMOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:14:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: David Woodhouse <dwmw2@infradead.org>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>
Subject: Re: [PATCH v3] x86, vt-d: enable x2apic opt out
In-Reply-To: Your message of "Tue, 24 May 2011 08:38:47 BST."
             <1306222728.2627.49.camel@i7.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <1306161148-3987-1-git-send-email-youquan.song@intel.com> <7457.1306203521@localhost> <20110524153614.GA19080@linux-youquan.bj.intel.com> <17321.1306210686@localhost>
            <1306222728.2627.49.camel@i7.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306239208_2659P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 24 May 2011 08:13:28 -0400
Message-ID: <5843.1306239208@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DDBA0EE.0010,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306239208_2659P
Content-Type: text/plain; charset=us-ascii

On Tue, 24 May 2011 08:38:47 BST, David Woodhouse said:
> On Tue, 2011-05-24 at 05:18 +0100, Valdis.Kletnieks@vt.edu wrote:
> > Do we want an actual WARN there, complete with stack traceback and
> > all?
> > 
> > Or did you intend a pr_warn or printk(KERN_WARNING or similar?
> 
> The traceback has been very useful in other BIOS issues, because it gets
> tracked and counted on kerneloops.org along with platform
> identification. So we have been able to track down the major offenders
> of some of the most egregious BIOS stupidities and make *some* progress
> on getting them to improve the untested dross they habitually turn out.

Oh OK... that probably is a good idea then.

--==_Exmh_1306239208_2659P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN26DocC3lWbTT17ARAuviAJ0f/hFpxuZc2F0O/KmlnIpwmLgB3QCfcFUd
az1zC4vxr2+lbtMH10gNKzQ=
=NFFD
-----END PGP SIGNATURE-----

--==_Exmh_1306239208_2659P--

