Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1IBQIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:08:02 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58227 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1IBQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:08:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next RCU complaint during boot
In-Reply-To: Your message of "Fri, 02 Sep 2011 03:53:32 +0200."
             <20110902015330.GA28121@somewhere.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <8867.1314894817@turing-police.cc.vt.edu> <20110902014424.GB2405@linux.vnet.ibm.com>
            <20110902015330.GA28121@somewhere.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314979603_2710P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Sep 2011 12:06:43 -0400
Message-ID: <6595.1314979603@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E60FF17.00EC,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314979603_2710P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Sep 2011 03:53:32 +0200, Frederic Weisbecker said:
> On Thu, Sep 01, 2011 at 06:44:24PM -0700, Paul E. McKenney wrote:

> > This is a bug where someone uses RCU at a time when RCU has been told
> > that the CPU is in dyntick-idle mode.  Frederic Weisbecker has some
> > patches that should address this.
> 
> Yep, see there: https://lkml.org/lkml/2011/8/20/81

Hmm.. .would test, but didn't apply cleanly to -next from Wednesday.  Of course,
I was trying to do it before corn flakes, so I probably got the patches out of order.
WIll re-try this evening if I get a chance.

--==_Exmh_1314979603_2710P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFOYP8TcC3lWbTT17ARAumUAJ4609ziLbsR2wfq/kcoPuMGjNU96QCXQ1+m
yywB+X3tClZYNNKRokkSLA==
=RrNe
-----END PGP SIGNATURE-----

--==_Exmh_1314979603_2710P--

