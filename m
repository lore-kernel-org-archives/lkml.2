Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2LXNiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:38:54 -0500
Received: from gmmr4.centrum.cz ([46.255.227.253]:48528 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2LXNix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:38:53 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 24 Dec 2012 14:38:50 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121206095423.GB10931@dhcp22.suse.cz>, <20121210022038.E6570D37@pobox.sk>, <20121210094318.GA6777@dhcp22.suse.cz>, <20121210111817.F697F53E@pobox.sk>, <20121210155205.GB6777@dhcp22.suse.cz>, <20121217023430.5A390FD7@pobox.sk>, <20121217163203.GD25432@dhcp22.suse.cz>, <20121217192301.829A7020@pobox.sk>, <20121217195510.GA16375@dhcp22.suse.cz>, <20121218152223.6912832C@pobox.sk> <20121218152004.GA25208@dhcp22.suse.cz>
In-Reply-To: <20121218152004.GA25208@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121224143850.B611B3C3@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>OK, good to hear and fingers crossed. I will try to get back to the
>original problem and a better solution sometimes early next year when
>all the things settle a bit.


Btw, i noticed one more thing when problem is happening (=when any cgroup is stucked), i fogot to mention it before, sorry :( . It's related to HDDs, something is slowing them down in a strange way. All services are working normally and i really cannot notice any slowness, the only thing which i noticed is affeceted is our backup software ( www.Bacula.org ). When problem occurs at night, so it's happening when backup is running, backup is extremely slow and usually don't finish until i kill processes inside affected cgroup (=until i resolve the problem). Backup software is NOT doing big HDD bandwidth BUT it's doing quite huge number of disk operations (it needs to stat every file and directory). I believe that only speed of disk operations are affected and are very slow.

Merry christmas!
