Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1DPO1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:27:52 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42530 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1DPO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:27:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex scheduling problems
In-Reply-To: Your message of "Sat, 16 Apr 2011 12:08:40 +0200."
             <1302948520.32491.10.camel@twins>
From: Valdis.Kletnieks@vt.edu
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com> <1302913676-14352-5-git-send-email-robert.richter@amd.com> <1302943877.32491.9.camel@twins> <20110416094348.GA24711@elte.hu>
            <1302948520.32491.10.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302964013_54890P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Apr 2011 10:26:53 -0400
Message-ID: <61040.1302964013@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DA9A731.00F8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302964013_54890P
Content-Type: text/plain; charset=us-ascii

On Sat, 16 Apr 2011 12:08:40 +0200, Peter Zijlstra said:
> These cases only exist on AMD F15, I don't think there's many people
> with such systems around.

Didn't they say similar things about the first Itaniums? :)


--==_Exmh_1302964013_54890P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqactcC3lWbTT17ARAnl0AKCSsE5t/RHFnpkZhvq/+3uMADcmfQCeOpZ7
T+HEef9EVo+dd8ZSxLO7QN0=
=izQL
-----END PGP SIGNATURE-----

--==_Exmh_1302964013_54890P--

