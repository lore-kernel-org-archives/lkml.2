Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1C2BbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 21:31:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46660 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1C2BbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 21:31:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 10:24:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: update documentation to describe
 usage_in_bytes
Message-Id: <20110329102445.a46760ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110329101511.d30f3518.nishimura@mxp.nes.nec.co.jp>
References: <20110321102420.GB26047@tiehlicka.suse.cz>
	<20110322091014.27677ab3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110322104723.fd81dddc.nishimura@mxp.nes.nec.co.jp>
	<20110322073150.GA12940@tiehlicka.suse.cz>
	<20110323092708.021d555d.nishimura@mxp.nes.nec.co.jp>
	<20110323133517.de33d624.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328085508.c236e929.nishimura@mxp.nes.nec.co.jp>
	<20110328132550.08be4389.nishimura@mxp.nes.nec.co.jp>
	<20110328074341.GA5693@tiehlicka.suse.cz>
	<20110328181127.b8a2a1c5.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328094820.GC5693@tiehlicka.suse.cz>
	<20110328193108.07965b4a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110329101511.d30f3518.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 10:15:11 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Since 569b846d(memcg: coalesce uncharge during unmap/truncate), we do batched
> (delayed) uncharge at truncation/unmap. And since cdec2e42(memcg: coalesce
> charging via percpu storage), we have percpu cache for res_counter.
> 
> These changes improved performance of memory cgroup very much, but made
> res_counter->usage usually have a bigger value than the actual value of memory usage.
> So, *.usage_in_bytes, which show res_counter->usage, are not desirable for precise
> values of memory(and swap) usage anymore.
> 
> Instead of removing these files completely(because we cannot know res_counter->usage
> without them), this patch updates the meaning of those files.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

