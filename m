Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2FFDhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:37:32 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48154 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2FFDhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:37:31 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: next-20120604 WARNING: at block/blk-cgroup.c:867
In-Reply-To: Your message of "Tue, 05 Jun 2012 23:23:40 -0400."
             <3785.1338953020@turing-police.cc.vt.edu>
From: valdis.kletnieks@vt.edu
References: <3785.1338953020@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1338953847_2145P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jun 2012 23:37:27 -0400
Message-ID: <4824.1338953847@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.180 mail-yx0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4FCED07A.0079,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1338953847_2145P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4818.1338953846.1@turing-police.cc.vt.edu>

On Tue, 05 Jun 2012 23:23:40 -0400, Valdis Kletnieks said:

(hit SEND a tad too soon)

> % zgrep CGR /proc/config.gz
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_CGROUP_MEM_RES_CTLR=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
> # CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> # CONFIG_NET_CLS_CGROUP is not set
> CONFIG_NETPRIO_CGROUP=m

Also, I have this:

zgrep CFQ /proc/config.gz
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_CFQ=y

Am guessing that lacking CFQ_GROUP_IOSCHED is what causes the indigestion.


--==_Exmh_1338953847_2145P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT87QdgdmEQWDXROgAQLJLxAAu8IBtz/yFaPj7F4owNq6RmPK+sEKzric
4hQdsN568Mvk3RAGJlVGLHd1zJ2O65n3d7s+ajb/U+WT+oN98F3dO7OnoXDlhXaG
eN98GvtPsSrCKfgW3RPxL/jbxf//l93QdPgIAC+K5BwuHo0MoRfef/04ah5pfmLI
rwUKqO1gtQvisfS6nG6ubGOrFvUk48HAdMppv/bA6m/Y+CvtbjKGC9mfsAHCqNyV
abZYV2EfX8Qdi9gBqg9oXvH9EqywmfF81ibiIhpt9lulahQC1XnfYgcaOOHX6d6Z
la0zJXiaGqqXAqqcDO/t7os3PoihVRzTZrNq+Ci53pPsz0VTF+Zuc0C1wik5P5GU
EuhfabVSjTiFuPcXKYd9epAmSoxkGScjgh2PROO3uMfiPjoKRzneOMRQsUIQVK2C
6fx6KENewLbqP5qgCoFV3kbdvhAFlByc5cN6ymlpJENyqC8u/5rufJz9v29enDeQ
FxE7CaafmAKI6TXKZwlBTajIvVFgcda3AsxrnDCRtZU0gsJHQviOcvCUW+SfiUFU
cf6keTu2YrwT8kSevfey9LjkymcGqTJvW5xnKYnWHLK79UbEFHDGUEN5h8IvzZcP
H32TPQXI3py0DMS56L3NeLUyS41VcNlmMGAoDGykcpqRKcvK2XEFV1UBeZFVaW+8
+Iknq6KUEek=
=HVtR
-----END PGP SIGNATURE-----

--==_Exmh_1338953847_2145P--

