Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2LEBgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:36:49 -0500
Received: from gmmr4.centrum.cz ([46.255.227.253]:36842 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab2LEBgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:36:47 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Wed, 05 Dec 2012 02:36:44 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121126131837.GC17860@dhcp22.suse.cz>, <20121126132149.GD17860@dhcp22.suse.cz>, <20121130032918.59B3F780@pobox.sk>, <20121130124506.GH29317@dhcp22.suse.cz>, <20121130144427.51A09169@pobox.sk>, <20121130144431.GI29317@dhcp22.suse.cz>, <20121130160811.6BB25BDD@pobox.sk>, <20121130153942.GL29317@dhcp22.suse.cz>, <20121130165937.F9564EBE@pobox.sk>, <20121130161923.GN29317@dhcp22.suse.cz> <20121203151601.GA17093@dhcp22.suse.cz>
In-Reply-To: <20121203151601.GA17093@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121205023644.18C3006B@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The following should print the traces when we hand over ENOMEM to the
>caller. It should catch all charge paths (migration is not covered but
>that one is not important here). If we don't see any traces from here
>and there is still global OOM striking then there must be something else
>to trigger this.
>Could you test this with the patch which aims at fixing your deadlock,
>please? I realise that this is a production environment but I do not see
>anything relevant in the code.


Michal,

i think/hope this is what you wanted:
http://www.watchdog.sk/lkml/oom_mysqld2
