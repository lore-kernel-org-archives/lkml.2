Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2KZUqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:46:43 -0500
Received: from gmmr7.centrum.cz ([46.255.225.249]:44960 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab2KZUql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:46:41 -0500
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>,
        =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_=2Dmm=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 26 Nov 2012 21:46:38 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>
References: <20121125120524.GB10623@dhcp22.suse.cz>, <20121125135542.GE10623@dhcp22.suse.cz>, <20121126013855.AF118F5E@pobox.sk>, <20121126131837.GC17860@dhcp22.suse.cz>, <20121126174622.GE2799@cmpxchg.org>, <20121126180444.GA12602@dhcp22.suse.cz>, <20121126182421.GB2301@cmpxchg.org>, <20121126190329.GB12602@dhcp22.suse.cz>, <20121126192941.GC2301@cmpxchg.org>, <20121126200848.GC12602@dhcp22.suse.cz> <20121126201918.GD2301@cmpxchg.org>
In-Reply-To: <20121126201918.GD2301@cmpxchg.org>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121126214638.64723F01@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This issue has been around for a while so frankly I don't think it's
>urgent enough to rush things.


Well, it's quite urgent at least for us :( i wasn't reported this so far cos i wasn't sure it's a kernel thing. I will be really happy and thankfull if fix for this can go to 3.2 in some near future.. Thank you very much!

azur
