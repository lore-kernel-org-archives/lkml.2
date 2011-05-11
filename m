Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1EKWji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:39:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52278 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1EKWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:39:37 -0400
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
        "Liu, Kent" <kent.liu@intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
In-Reply-To: Your message of "Wed, 11 May 2011 16:39:38 BST."
             <1305128379.30435.171.camel@i7.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com> <1305126431.30435.163.camel@i7.infradead.org> <20110512033923.GA19708@linux-youquan.bj.intel.com>
            <1305128379.30435.171.camel@i7.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305153485_2793P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 11 May 2011 18:38:05 -0400
Message-ID: <33128.1305153485@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DCB0FD0.0105,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305153485_2793P
Content-Type: text/plain; charset=us-ascii

On Wed, 11 May 2011 16:39:38 BST, David Woodhouse said:

> Can't we just line up the substandard BIOS engineers against the wall,
> and shoot them?

Linus has stated "We do not trust BIOS tables, because BIOS writers are
invariably totally incompetent crack-addicted monkeys."

Which means if we shoot them, the ASPCA and PETA will be on our case for it...

--==_Exmh_1305153485_2793P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyw/NcC3lWbTT17ARAlOmAJ9cUMiy4Sdnv42aFmD24al5bIcE6ACgvEOz
28xXgxwKizfXQkkagnWwn40=
=Azux
-----END PGP SIGNATURE-----

--==_Exmh_1305153485_2793P--

