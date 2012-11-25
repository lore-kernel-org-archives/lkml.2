Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2KYN1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:27:13 -0500
Received: from gmmr1.centrum.cz ([46.255.225.252]:59136 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab2KYN1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:27:12 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Sun, 25 Nov 2012 14:27:09 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>
References: <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk>, <20121123074023.GA24698@dhcp22.suse.cz>, <20121123102137.10D6D653@pobox.sk>, <20121123100438.GF24698@dhcp22.suse.cz>, <20121123155904.490039C5@pobox.sk>, <20121125101707.GA10623@dhcp22.suse.cz>, <20121125133953.AD1B2F0A@pobox.sk> <20121125130208.GC10623@dhcp22.suse.cz>
In-Reply-To: <20121125130208.GC10623@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121125142709.19F4E8C2@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Thank you very much, i will install it ASAP (probably this night).
>
>Please don't. If my analysis is correct which I am almost 100% sure it
>is then it would cause excessive logging. I am sorry I cannot come up
>with something else in the mean time.


Ok then. I will, meanwhile, try to contact Andrea Righi (author of cgroup-task etc.) and ask him to send here his opinion about relation between freezes and his patches. Maybe it's some kind of a bug in memcg which don't appear in current vanilla code and is triggered by conditions created by, for example, cgroup-task. I noticed that there is always the exact number of freezed processes as the limit set for number of tasks by cgroup-task (i already tried to raise this limit AFTER the cgroup was freezed, didn't change anything). I'm sure it's not the problem with cgroup-task alone, it's 100% related also to memcg (but maybe there must be the combination of both of them).

Thank you so far for your time!

azur
