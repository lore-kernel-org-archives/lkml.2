Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1A0Bzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:55:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab1A0Bzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:55:43 -0500
Date: Wed, 26 Jan 2011 17:55:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] memcg: fix res_counter_read_u64 lock aware (Was Re:
 [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110126175528.1cc73ba9.akpm@linux-foundation.org>
In-Reply-To: <20110127103431.04432944.kamezawa.hiroyu@jp.fujitsu.com>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
	<20110126183023.GB2401@cmpxchg.org>
	<xr9362tbl83f.fsf@gthelen.mtv.corp.google.com>
	<20110126142909.0b710a0c.akpm@linux-foundation.org>
	<20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127095342.3d81cf5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110126170824.ef2ab571.akpm@linux-foundation.org>
	<20110127103431.04432944.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 10:34:31 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I wonder making memcg's counter to use 32bit and record usage in the number
> of pages may be a simple way...

That would be better, yes.
