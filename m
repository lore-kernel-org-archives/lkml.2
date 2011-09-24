Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab1IXAbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 20:31:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41387 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1IXAbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 20:31:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Venki Pallipadi <venki@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
In-Reply-To: Your message of "Fri, 23 Sep 2011 16:50:15 PDT."
             <CABeCy1aS2mb3oLjCf5kbAN55MuePS6hbs+2v9Z=X4bFPOmH7HQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1316804080-6396-1-git-send-email-venki@google.com> <4E7CDE1F.90004@linux.intel.com>
            <CABeCy1aS2mb3oLjCf5kbAN55MuePS6hbs+2v9Z=X4bFPOmH7HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316824182_33036P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 20:29:42 -0400
Message-ID: <39635.1316824182@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E7D2479.0042,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316824182_33036P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Sep 2011 16:50:15 PDT, Venki Pallipadi said:

> Yes. I kept the sysctl there for this RFC, so that anyone testing this
> can easily switch this on/off and measure the impact. Will remove it
> in updates..

I presume we have a plan to ensure the sysctl gets removed/disabled
for releases, so it doesn't escape and become official API we then have
to deprecate? (=22We'll stuff it in at the front of the 3.2 merge window,=
 and
nuke it around 3.2-rc5=22 is OK by me...)

--==_Exmh_1316824182_33036P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfSR2cC3lWbTT17ARAqPPAKCfMNBUa8NKEzqTjnh4mCNMaoyxsgCgpZRx
a6rlmw/Zumxz6NC7QWnJ91U=
=dLP5
-----END PGP SIGNATURE-----

--==_Exmh_1316824182_33036P--

