Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031418Ab2COAuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:50:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36800 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965372Ab2COAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:50:18 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F613C5B.8030304@jp.fujitsu.com>
Date: Thu, 15 Mar 2012 09:48:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Suleiman Souhlal <ssouhlal@FreeBSD.org>, cgroups@vger.kernel.org,
        suleiman@google.com, penberg@kernel.org, cl@linux.com,
        yinghan@google.com, hughd@google.com, gthelen@google.com,
        peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org,
        mgorman@suse.de, James.Bottomley@HansenPartnership.com,
        linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org> <4F5C5E54.2020408@parallels.com> <20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com> <4F5F236A.1070609@parallels.com> <20120314091526.3c079693.kamezawa.hiroyu@jp.fujitsu.com> <4F608F25.3010700@parallels.com>
In-Reply-To: <4F608F25.3010700@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/14 21:29), Glauber Costa wrote:


>>   - What happens when a new cgroup created ?
> 
> mem_cgroup_create() is called =)
> Heh, jokes apart, I don't really follow here. What exactly do you mean? 
> There shouldn't be anything extremely out of the ordinary.
> 


Sorry, too short words.

Assume a cgroup with
	cgroup.memory.limit_in_bytes=1G
	cgroup.memory.kmem.limit_in_bytes=400M

When a child cgroup is created, what should be the default values.
'unlimited' as current implementation ?
Hmm..maybe yes.

Thanks,
-Kame

