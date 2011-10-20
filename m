Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1JTVL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:11:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37463 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1JTVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:11:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andi Kleen <andi@firstfloor.org>
Cc: p.herz@profihost.ag, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
In-Reply-To: Your message of "Tue, 18 Oct 2011 08:51:54 PDT."
             <m2ipnmz49x.fsf@firstfloor.org>
From: Valdis.Kletnieks@vt.edu
References: <4E9D53FF.7090609@profihost.ag>
            <m2ipnmz49x.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319145104_4595P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Oct 2011 17:11:44 -0400
Message-ID: <16605.1319145104@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4EA08E91.00FB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319145104_4595P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Oct 2011 08:51:54 PDT, Andi Kleen said:
> Philipp Herz - Profihost AG <p.herz@profihost.ag> writes:
> 
> > After updating kernel (x86_64) to stable version 3 there are a few
> > messages appearing in the kernel log such as
> >
> > kworker/0:1: page allocation failure: order:1, mode:0x20
> > mysql: page allocation failure: order:1, mode:0x20
> > php5: page allocation failure: order:1, mode:0x20
> 
> You just ran out of memory.

I read it as "Why is this happening when the previous kernel didn't have
this issue?", which is a *much* more complicated question...

--==_Exmh_1319145104_4595P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOoI6QcC3lWbTT17ARAkkLAJ9WCqdT9tzugn+2fZPo0IBrKRqV0gCg3jQ6
7+hbt8DWagvw30yaqK4rwMo=
=x9BE
-----END PGP SIGNATURE-----

--==_Exmh_1319145104_4595P--

