Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1HIICT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1HIICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:02:17 -0400
Date: Tue, 9 Aug 2011 10:01:59 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        abrestic@google.com
Subject: Re: [PATCH v3] memcg: add memory.vmscan_stat
Message-ID: <20110809080159.GA32015@redhat.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
 <20110808124333.GA31739@redhat.com>
 <20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:33:45AM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 8 Aug 2011 14:43:33 +0200
> Johannes Weiner <jweiner@redhat.com> wrote:
> > On a non-technical note: as Ying Han and I were the other two people
> > working on reclaim and statistics, it really irks me that neither of
> > us were CCd on this.  Especially on such a controversial change.
> 
> I always drop CC if no reply/review comes.

There is always the possibility that a single mail in an otherwise
unrelated patch series is overlooked (especially while on vacation ;).
Getting CCd on revisions and -mm inclusion is a really nice reminder.

Unless there is a really good reason not to (is there ever?), could
you please keep CCs?
