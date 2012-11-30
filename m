Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031018Ab2K3P7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:59:41 -0500
Received: from gmmr8.centrum.cz ([46.255.227.254]:39879 "EHLO gmmr8.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031001Ab2K3P7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:59:40 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Fri, 30 Nov 2012 16:59:37 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121125120524.GB10623@dhcp22.suse.cz>, <20121125135542.GE10623@dhcp22.suse.cz>, <20121126013855.AF118F5E@pobox.sk>, <20121126131837.GC17860@dhcp22.suse.cz>, <20121126132149.GD17860@dhcp22.suse.cz>, <20121130032918.59B3F780@pobox.sk>, <20121130124506.GH29317@dhcp22.suse.cz>, <20121130144427.51A09169@pobox.sk>, <20121130144431.GI29317@dhcp22.suse.cz>, <20121130160811.6BB25BDD@pobox.sk> <20121130153942.GL29317@dhcp22.suse.cz>
In-Reply-To: <20121130153942.GL29317@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121130165937.F9564EBE@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Here is the full boot log:
>> www.watchdog.sk/lkml/kern.log
>
>The log is not complete. Could you paste the comple dmesg output? Or
>even better, do you have logs from the previous run?


What is missing there? All kernel messages are logging into /var/log/kern.log (it's the same as dmesg), dmesg itself was already rewrited by other messages. I think it's all what that kernel printed.
