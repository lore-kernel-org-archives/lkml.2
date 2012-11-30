Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab2K3Noc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:44:32 -0500
Received: from gmmr3.centrum.cz ([46.255.225.251]:55084 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab2K3Noa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:44:30 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Fri, 30 Nov 2012 14:44:27 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121123074023.GA24698@dhcp22.suse.cz>, <20121123102137.10D6D653@pobox.sk>, <20121123100438.GF24698@dhcp22.suse.cz>, <20121125011047.7477BB5E@pobox.sk>, <20121125120524.GB10623@dhcp22.suse.cz>, <20121125135542.GE10623@dhcp22.suse.cz>, <20121126013855.AF118F5E@pobox.sk>, <20121126131837.GC17860@dhcp22.suse.cz>, <20121126132149.GD17860@dhcp22.suse.cz>, <20121130032918.59B3F780@pobox.sk> <20121130124506.GH29317@dhcp22.suse.cz>
In-Reply-To: <20121130124506.GH29317@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121130144427.51A09169@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Anyway your system is under both global and local memory pressure. You
>didn't see apache going down previously because it was probably the one
>which was stuck and could be killed.
>Anyway you need to setup your system more carefully.


There is, also, an evidence that system has enough of memory! :) Just take column 'rss' from process list in OOM message and sum it - you will get 2489911. It's probably in KB so it's about 2.4 GB. System has 14 GB of RAM so this also match data on my graph - 2.4 is about 17% of 14.

azur
