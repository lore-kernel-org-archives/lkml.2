Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2AYL7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:59:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50529 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab2AYL7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:59:08 -0500
Date: Wed, 25 Jan 2012 11:59:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120125115906.GG3687@opensource.wolfsonmicro.com>
References: <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <1327435069.2767.1.camel@edumazet-laptop>
 <20120124211137.GD2381@linux.vnet.ibm.com>
 <20120124220700.GA11725@sirena.org.uk>
 <20120124224345.GG2381@linux.vnet.ibm.com>
 <20120124235123.GA32176@opensource.wolfsonmicro.com>
 <20120125013604.GI2381@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Content-Disposition: inline
In-Reply-To: <20120125013604.GI2381@linux.vnet.ibm.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2012 at 05:36:04PM -0800, Paul E. McKenney wrote:
> On Tue, Jan 24, 2012 at 11:51:24PM +0000, Mark Brown wrote:

> > Well, that depends.  Anything you're actually accomplishing when you're
> > optimising at that level is at the less than a milliwatt level.

> OK, good point.

> In the meantime, here are some alleged fixes for the corresponding bug in
> the ARM tree.  Some of these are "interesting" in the sense that RCU can
> be used more deeply in the idle loop than I would believe to be safe,
> for example, via locking->lockdep->RCU after some interesting pieces
> of hardware have been shut off.  I took my best guess and commented the
> ones that I am least sure of.

> Thoughts?  Other than I need to CC a cast of thousands?  (I cannot break
> this up without having git bisect points with busted RCU on ARM.)

Not really - I don't know ARM CPU side stuff in any detail, I mostly
work on things external to the SoCs.

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH+6DAAoJEBus8iNuMP3dm4sP/0yWVjlHOg37uWGd1CFfb46G
n8nAaQPNaDE9dm+xCoDWJv+LoGtMmBsIWeAnOP2+S/trtTtF1Ge7kBBibZGCrR3y
ZxL//dDsgIG8leIw3mi7893HJsT+vANeVt10Pn74fDo22tHzvJQ86vr7EdL/icD+
7H9EVNDshU89hoO/3SsCj0JXcopl9Z+dUnUxJxJGa6JNS2k8aHq4g1STgr35KLay
Eu7dmw5gFiOVonxwJYZmPuN5qdZCCHyN9aMjwJauB2Ahzgm6NsxBBJltSIcnQJuu
VyT8iYjtNlgy4PnCv1s1SGuHnmlbtVwCx1Obi0y1kTIbYiuoIVe0Uq7X7sw9Zs7L
azRJRCLzet0ar/ycAePJ/VJQRKZOTZFPQErKSASeV8F714BrmD+nw81NACge12+F
32mPx4w5LXxCKuxkFKOU7N20PxlWlGOPLaFQjoCvb+QMcKtKFnF0QHmURg+q82xh
vQmCgJrD/eVCmKQTI2znssv4rFeocUZv4ItO/NR0eA13lp6ft/ipVOLZevRNdp+4
Z2/2M75wjXmf/pDYXrMGXItW3c2AChYJObkMmnnCAShCoZpdLvMHWQ0JGYf/oOIE
3Tvm27YN86/lJxCmtrTw5MQ+sVKXyYiKv5lTnS7z0gbuFB55wTJY1r+m1pllgL9T
buHuTkes7bmw6LtNPpza
=urLx
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
