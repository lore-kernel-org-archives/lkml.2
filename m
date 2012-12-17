Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2LQSXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:23:11 -0500
Received: from gmmr1.centrum.cz ([46.255.225.252]:35944 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2LQSXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:23:05 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 17 Dec 2012 19:23:01 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121203151601.GA17093@dhcp22.suse.cz>, <20121205023644.18C3006B@pobox.sk>, <20121205141722.GA9714@dhcp22.suse.cz>, <20121206012924.FE077FD7@pobox.sk>, <20121206095423.GB10931@dhcp22.suse.cz>, <20121210022038.E6570D37@pobox.sk>, <20121210094318.GA6777@dhcp22.suse.cz>, <20121210111817.F697F53E@pobox.sk>, <20121210155205.GB6777@dhcp22.suse.cz>, <20121217023430.5A390FD7@pobox.sk> <20121217163203.GD25432@dhcp22.suse.cz>
In-Reply-To: <20121217163203.GD25432@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121217192301.829A7020@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>[Ohh, I am really an idiot. I screwed the first patch]
>-       bool oom = true;
>+       bool oom = !(gfp_mask | GFP_MEMCG_NO_OOM);
>
>Which obviously doesn't work. It should read !(gfp_mask &GFP_MEMCG_NO_OOM).
>  No idea how I could have missed that. I am really sorry about that.


:D no problem :) so, now it should really work as expected and completely fix my original problem? is it safe to apply it on 3.2.35? Thank you very much!

azur
