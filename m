Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2KVWek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:34:40 -0500
Received: from gmmr5.centrum.cz ([46.255.225.250]:52568 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2KVWeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:34:37 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Thu, 22 Nov 2012 23:34:34 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>
References: <20121121200207.01068046@pobox.sk>, <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk> <20121122214249.GA20319@dhcp22.suse.cz>
In-Reply-To: <20121122214249.GA20319@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121122233434.3D5E35E6@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Btw. is this stack stable or is the task bouncing in some loop?


Not sure, will check it next time.



>And finally could you post the disassembly of your version of
>mem_cgroup_handle_oom, please?


How can i do this?



>What does your kernel log says while this is happening. Are there any
>memcg OOM messages showing up?


I will get the logs next time.


Thank you!

azur
