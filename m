Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab1ITNmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:42:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47979 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1ITNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:42:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: POHMELFS is back
In-Reply-To: Your message of "Tue, 20 Sep 2011 09:58:12 +0400."
             <20110920055812.GA7910@ioremap.net>
From: Valdis.Kletnieks@vt.edu
References: <20110919061302.GA19699@ioremap.net> <9891.1316455851@turing-police.cc.vt.edu>
            <20110920055812.GA7910@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316526117_2734P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Sep 2011 09:41:57 -0400
Message-ID: <29686.1316526117@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E789828.0120,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316526117_2734P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Sep 2011 09:58:12 +0400, Evgeniy Polyakov said:
> On Mon, Sep 19, 2011 at 02:10:51PM -0400, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > On Mon, 19 Sep 2011 10:13:02 +0400, Evgeniy Polyakov said:
> > > more that 4 Gb/s of bandwidth from each datacenter,
> > Also not at all impressive per-node if we're talking an average of 50 nodes per
> > data center.  I'm currently waiting for some 10GigE to be provisioned at the
> > moment because we're targeting close to a giga*byte*/sec per server.
>
> If you get 10 times more bandwidth you will not be able to saturate it
> with 10 times less servers.

The point is that the solutions we're looking at are able to drive enough I/O
*per server* that we need to look at 10GigE and Infiniband connections. Your
numbers currently indicate about 5T of disk and 75 megabit of throughput per
node, while current solutions are doing about 100T and pushing a 10GigE per
node.  So you have a *lot* of per-server scaling work to do still...

>                                              Scaling to hundreds of server nodes is a
> good result, since we evenly balance all IO between nodes and no single
> server is disk or network bound.

You missed the point. Scaling to hundreds of server nodes is a nice
*theoretical* result, but one that's not going to get a lot of traction out in
the real world, where the *per server* scaling matters too.  Which is my boss
more likely to be willing to spend money on - a solution that has 50 servers
per datacenter to deliver 4 Gb/sec per data center, or one that is delivering
that much *per server*? Remember - servers cost money, rack space costs money,
hardware maintenance contracts cost money, electricity and cooling cost money ,
network connectivity costs money, sysadmin time to manage each node costs money
- so in the real world, the solution that uses the smallest number of servers
to get to the target aggregate is probably going to win.

Looked at differently - if I'm currently targeting multiple gigabytes/sec throughput
to a petabyte of disk from a half-dozen servers, how big and fast a disk farm
could I build if I had 50 servers in the room, or 200 across datacenters?

--==_Exmh_1316526117_2734P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOeJglcC3lWbTT17ARAqg0AKCJDlwB75Sk4dhd9glDj35UrAIUZQCg15+H
Z3Uuyil0lY9pmdLfNqVQ+qQ=
=HCGy
-----END PGP SIGNATURE-----

--==_Exmh_1316526117_2734P--

