Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1D0DQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:16:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37763 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1D0DQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:16:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 12:09:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v2] fix get_scan_count for working well with small
 targets
Message-Id: <20110427120931.a993890f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110427105031.db203b95.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110426181724.f8cdad57.kamezawa.hiroyu@jp.fujitsu.com>
	<20110426135934.c1992c3e.akpm@linux-foundation.org>
	<20110427105031.db203b95.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 10:50:31 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 26 Apr 2011 13:59:34 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > What about simply removing the nr_saved_scan logic and permitting small
> > scans?  That simplifies the code and I bet it makes no measurable
> > performance difference.
> > 
> 
> ok, v2 here. How this looks ?
> For memcg, I think I should add select_victim_node() for direct reclaim,
> then, we'll be tune big memcg using small memory on a zone case.
> 


Ah, sorry this v2 doesn't remove nr_saved_scan in reclaim_stat. ...
I will send v3.

