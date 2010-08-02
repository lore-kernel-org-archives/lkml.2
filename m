Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0HBPJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:09:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47194 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0HBPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:09:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: hp fk <fkhp101@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
In-Reply-To: Your message of "Mon, 02 Aug 2010 23:02:01 +0800."
             <AANLkTik8DSLFeGqHspYjykt_vCF7SxupKSxKcB2LLRhj@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com> <215375.1280753770@localhost> <AANLkTi=keL2rUzxdxgscTU9cQSNxOnAtGVuAwTq9Wfuq@mail.gmail.com> <6501.1280759131@localhost>
            <AANLkTik8DSLFeGqHspYjykt_vCF7SxupKSxKcB2LLRhj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280761746_3871P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Aug 2010 11:09:06 -0400
Message-ID: <8023.1280761746@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4C56DF92.0270,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280761746_3871P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Aug 2010 23:02:01 +0800, you said:

>  HTTP if more of an access protocol,the logical network is woven in
> the web page controled by html, the network needed is formed and take
> part in by tcp/ip protocol which usually lies in kernel.
> 
> Kademlia itself has the responsibility to weave the p2p network and
> bring a node into the p2p network before access can be done.

You're still failing to explain why the kernel needs to do this
rather than some -lkademlia in userspace.


--==_Exmh_1280761746_3871P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMVt+ScC3lWbTT17ARAq86AJ42F83jxnhyxtsmcAwcpptyFgFY1QCdF+5E
0Iihs0UgcjQom7mf8Nv6+EY=
=gfCY
-----END PGP SIGNATURE-----

--==_Exmh_1280761746_3871P--

