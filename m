Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1ADS5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:57:21 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:45422 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1ADS5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:57:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
In-Reply-To: Your message of "Tue, 04 Jan 2011 12:10:19 +0100."
             <1294139419.2016.115.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <1293464211.2695.104.camel@localhost> <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com> <1293526288.2457.4.camel@minggr.sh.intel.com> <1294052312.2016.50.camel@laptop> <4D222926.9010206@zytor.com>
            <1294139419.2016.115.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294167327_4985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Jan 2011 13:55:27 -0500
Message-ID: <14831.1294167327@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D236D22.01A2,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294167327_4985P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Jan 2011 12:10:19 +0100, Peter Zijlstra said:

> X86_FEATURE_HT tells us the CPU supports telling us about HT,
> smp_num_siblings > 1 tells us the CPU is capable of HT.

A subtle but important distinction. Several laptops ago, I had a P4-M chip that
had FEATURE_HT, but num_siblings == 1.  ISTR trying to boot an SMP kernel on it
and it dying gloriously trying to bring up the non-existent other sibling.


--==_Exmh_1294167327_4985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNI20fcC3lWbTT17ARAmiNAKCq1zmxd5efht6hoIIpTIPrtTw4VACfUw5k
FR7AaPcoKVVx8Pe2fDzuIo4=
=L0Ut
-----END PGP SIGNATURE-----

--==_Exmh_1294167327_4985P--

