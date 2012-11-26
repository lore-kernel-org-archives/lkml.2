Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2KZAjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 19:39:00 -0500
Received: from gmmr3.centrum.cz ([46.255.225.251]:59858 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2KZAi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 19:38:58 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Mon, 26 Nov 2012 01:38:55 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>
References: <20121121200207.01068046@pobox.sk>, <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk>, <20121123074023.GA24698@dhcp22.suse.cz>, <20121123102137.10D6D653@pobox.sk>, <20121123100438.GF24698@dhcp22.suse.cz>, <20121125011047.7477BB5E@pobox.sk>, <20121125120524.GB10623@dhcp22.suse.cz> <20121125135542.GE10623@dhcp22.suse.cz>
In-Reply-To: <20121125135542.GE10623@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121126013855.AF118F5E@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This is hackish but it should help you in this case. Kamezawa, what do
>you think about that? Should we generalize this and prepare something
>like mem_cgroup_cache_charge_locked which would add __GFP_NORETRY
>automatically and use the function whenever we are in a locked context?
>To be honest I do not like this very much but nothing more sensible
>(without touching non-memcg paths) comes to my mind.


I installed kernel with this patch, will report back if problem occurs again OR in few weeks if everything will be ok. Thank you!

Btw, will this patch be backported to 3.2?

azur
