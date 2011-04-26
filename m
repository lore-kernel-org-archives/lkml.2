Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1DZDOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:14:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53639 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab1DZDOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:14:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] use oom_killer_disabled in all oom pathes
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimpidn07YRmm0gNDice3xo-tC8kow@mail.gmail.com>
References: <20110426115902.F374.A69D9226@jp.fujitsu.com> <BANLkTimpidn07YRmm0gNDice3xo-tC8kow@mail.gmail.com>
Message-Id: <20110426121555.F378.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 12:14:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 26, 2011 at 10:57 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> oom_killer_disable should be a global switch, also fit for oom paths
> >> other than __alloc_pages_slowpath
> >>
> >> Here add it to mem_cgroup_handle_oom and pagefault_out_of_memory as well.
> >
> > Can you please explain more? Why should? Now oom_killer_disabled is used
> > only hibernation path. so, Why pagefault and memcg allocation will be happen?
> 
> Indeed I'm using it in virtio balloon test, oom killer triggered when
> memory pressure is high.
> 
> literally oom_killer_disabled scope should be global, isn't it?

ok. virtio baloon seems fair usage. if you add new usage of oom_killer_disabled 
into the patch description, I'll ack this one.

thanks.


