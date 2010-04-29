Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750701Ab0D3Tl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:41:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56712 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0D3TlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:41:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-28-16-53 uploaded
In-Reply-To: Your message of "Wed, 28 Apr 2010 16:53:32 PDT."
             <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272576730_4529P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Apr 2010 17:32:10 -0400
Message-ID: <18962.1272576730@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4BD9FADE.023F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272576730_4529P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <18950.1272576722.1@localhost>

On Wed, 28 Apr 2010 16:53:32 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-04-28-16-53 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Dies trying to compile mm/slab.c because something screwed the pooch with
the definition of numa_mem_id(). My bets are on
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch

  CC      mm/slab.o
mm/slab.c: In function 'kmem_cache_init':
mm/slab.c:1506: error: 'numa_node' undeclared (first use in this function)
mm/slab.c:1506: error: (Each undeclared identifier is reported only once
mm/slab.c:1506: error: for each function it appears in.)
mm/slab.c:1506: warning: type defaults to 'int' in declaration of 'pscr_ret__'
mm/slab.c:1506: warning: type defaults to 'int' in declaration of 'type name'
mm/slab.c:1506: warning: cast from pointer to integer of different size
mm/slab.c:1506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:1506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:1506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:1506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c: In function 'setup_cpu_cache':
mm/slab.c:2148: error: 'numa_node' undeclared (first use in this function)
mm/slab.c:2148: warning: type defaults to 'int' in declaration of 'pscr_ret__'
mm/slab.c:2148: warning: type defaults to 'int' in declaration of 'type name'
mm/slab.c:2148: warning: cast from pointer to integer of different size
mm/slab.c:2148: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:2148: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:2148: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:2148: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c: In function 'do_drain':
mm/slab.c:2506: error: 'numa_node' undeclared (first use in this function)
mm/slab.c:2506: warning: type defaults to 'int' in declaration of 'pscr_ret__'
mm/slab.c:2506: warning: type defaults to 'int' in declaration of 'type name'
mm/slab.c:2506: warning: cast from pointer to integer of different size
mm/slab.c:2506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:2506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:2506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:2506: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c: In function 'cache_alloc_refill':
mm/slab.c:3039: error: 'numa_node' undeclared (first use in this function)
mm/slab.c:3039: warning: type defaults to 'int' in declaration of 'pscr_ret__'
mm/slab.c:3039: warning: type defaults to 'int' in declaration of 'type name'
mm/slab.c:3039: warning: cast from pointer to integer of different size
mm/slab.c:3039: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:3039: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:3039: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:3039: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c: In function 'cache_flusharray':
mm/slab.c:3575: error: 'numa_node' undeclared (first use in this function)
mm/slab.c:3575: warning: type defaults to 'int' in declaration of 'pscr_ret__'
mm/slab.c:3575: warning: type defaults to 'int' in declaration of 'type name'
mm/slab.c:3575: warning: cast from pointer to integer of different size
mm/slab.c:3575: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:3575: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:3575: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:3575: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c: In function 'cache_reap':
mm/slab.c:4139: error: 'numa_node' undeclared (first use in this function)
mm/slab.c:4139: warning: type defaults to 'int' in declaration of 'pscr_ret__'
mm/slab.c:4139: warning: type defaults to 'int' in declaration of 'type name'
mm/slab.c:4139: warning: cast from pointer to integer of different size
mm/slab.c:4139: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:4139: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:4139: warning: type defaults to 'int' in declaration of 'pfo_ret__'
mm/slab.c:4139: warning: type defaults to 'int' in declaration of 'pfo_ret__'
make[1]: *** [mm/slab.o] Error 1
make: *** [mm] Error 2

line 1506: node = numa_mem_id();
line 2148: cachep->nodelists[numa_mem_id()]->next_reap =
line 2506: int node = numa_mem_id();
line 3039: node = numa_mem_id();
line 3575: int node = numa_mem_id();
line 3139: int node = numa_mem_id();

Looks like a twisty little maze of cpp macros in each case, probably
related to this:

% grep -i numa .config
# CONFIG_NUMA is not set


--==_Exmh_1272576730_4529P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL2fracC3lWbTT17ARAglYAJ4zHslWLTLb6Vmm44YZs1Za/4435wCgwDXw
3WF1iHScvMxoATEH5JvMwKI=
=BRVh
-----END PGP SIGNATURE-----

--==_Exmh_1272576730_4529P--

