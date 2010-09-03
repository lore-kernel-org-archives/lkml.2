Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0ICUub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:50:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810Ab0ICUua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:50:30 -0400
Date: Fri, 3 Sep 2010 13:48:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/2][BUGFIX] fix memory isolation notifier return value
 check
Message-Id: <20100903134814.b7129f7b.akpm@linux-foundation.org>
In-Reply-To: <20100903165713.88249349.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100901121951.GC6663@tiehlicka.suse.cz>
	<20100901124138.GD6663@tiehlicka.suse.cz>
	<20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902082829.GA10265@tiehlicka.suse.cz>
	<20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902092454.GA17971@tiehlicka.suse.cz>
	<AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
	<20100902131855.GC10265@tiehlicka.suse.cz>
	<AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
	<20100902143939.GD10265@tiehlicka.suse.cz>
	<20100902150554.GE10265@tiehlicka.suse.cz>
	<20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100903165713.88249349.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 16:57:13 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Sorry, the 3rd patch for this set.

What happened with "[PATCH 2/2] Make is_mem_section_removable more
conformable with offlining code"?  You mentioned sending an updated
one, but I can't immediately find it.

Also, please do describe the impact of the problems which are being
fixed.  It helps me decide on priority and on
which-kernels-need-the-patch and it helps others when deciding
should-i-backport-this-into-my-kernel.

I think it'd be best to resend all of this, please.
