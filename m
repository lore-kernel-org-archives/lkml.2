Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1HKAGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:06:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41287 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1HKAGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:06:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Aug 2011 08:58:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Arend van Spriel <arend@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2][cleanup] memcg: renaming of mem variable to memcg
Message-Id: <20110811085842.c689749a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110810172929.23280.76419.sendpatchset@oc5400248562.ibm.com>
References: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com>
	<20110810172929.23280.76419.sendpatchset@oc5400248562.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 22:59:29 +0530
Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

>  The memcg code sometimes uses "struct mem_cgroup *mem" and sometimes uses
>  "struct mem_cgroup *memcg". This patch renames all mem variables to memcg in
>  source file.
> 
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Basically...

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

My concern is that this may HUNK with patches planend to be post..
but it seems rework will be small.

