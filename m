Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2LQBee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 20:34:34 -0500
Received: from gmmr3.centrum.cz ([46.255.225.251]:44425 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2LQBec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 20:34:32 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 17 Dec 2012 02:34:30 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121130165937.F9564EBE@pobox.sk>, <20121130161923.GN29317@dhcp22.suse.cz>, <20121203151601.GA17093@dhcp22.suse.cz>, <20121205023644.18C3006B@pobox.sk>, <20121205141722.GA9714@dhcp22.suse.cz>, <20121206012924.FE077FD7@pobox.sk>, <20121206095423.GB10931@dhcp22.suse.cz>, <20121210022038.E6570D37@pobox.sk>, <20121210094318.GA6777@dhcp22.suse.cz>, <20121210111817.F697F53E@pobox.sk> <20121210155205.GB6777@dhcp22.suse.cz>
In-Reply-To: <20121210155205.GB6777@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121217023430.5A390FD7@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I would try to limit changes to minimum. So the original kernel you were
>using + the first patch to prevent OOM from the write path + 2 debugging
>patches.


It didn't take off the whole system this time (but i was prepared to record a video of console ;) ), here it is:
http://www.watchdog.sk/lkml/oom_mysqld4
