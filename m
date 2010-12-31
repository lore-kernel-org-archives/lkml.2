Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0LaKqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:46:45 -0500
Received: from virgo.iok.hu ([212.40.97.103]:54241 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab0LaKqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:46:43 -0500
Date: Fri, 31 Dec 2010 11:46:38 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] sched, cgroup: Use exit hook to avoid use-after-free
 crash
Message-ID: <20101231104638.GM10557@genesis.frugalware.org>
References: <1293128670.2170.748.camel@laptop>
 <1293132304.6798.6.camel@marge.simson.net>
 <1293132862.25981.22.camel@laptop>
 <1293187425.7138.2.camel@marge.simson.net>
 <1293188091.25981.200.camel@laptop>
 <1293192999.18035.4.camel@marge.simson.net>
 <1293206353.29444.205.camel@laptop>
 <20101229152522.GA23825@elte.hu>
 <20101229230744.GA10557@genesis.frugalware.org>
 <1293789859.6839.97.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DTI0mi8ndc7Chjpu"
Content-Disposition: inline
In-Reply-To: <1293789859.6839.97.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DTI0mi8ndc7Chjpu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 31, 2010 at 11:04:19AM +0100, Mike Galbraith <efault@gmx.de> wrote:
> Your crash seems to be completely independent of Peter's patch.  It
> crashes here with your image/config/2.6.36 here regardless, and not 100%
> repeatably.  Sometimes it boots, sometimes not.

Oh, then ignore that. It's possible it's something qemu-specific, I
can't reproduce this one on my real machine.

--DTI0mi8ndc7Chjpu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAk0dtI4ACgkQe81tAgORUJbdfQCfcFzQXdA8nFgQ7yOEV7/h3ukQ
ZMoAmLGc6Z0438WTkGad458vCHbsz3o=
=73gP
-----END PGP SIGNATURE-----

--DTI0mi8ndc7Chjpu--
