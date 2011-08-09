Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1HIII6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:08:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54856 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1HIIIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:08:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 17:01:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        abrestic@google.com
Subject: Re: [PATCH v3] memcg: add memory.vmscan_stat
Message-Id: <20110809170118.880377f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110809080159.GA32015@redhat.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809080159.GA32015@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011 10:01:59 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Aug 09, 2011 at 08:33:45AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 8 Aug 2011 14:43:33 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > > On a non-technical note: as Ying Han and I were the other two people
> > > working on reclaim and statistics, it really irks me that neither of
> > > us were CCd on this.  Especially on such a controversial change.
> > 
> > I always drop CC if no reply/review comes.
> 
> There is always the possibility that a single mail in an otherwise
> unrelated patch series is overlooked (especially while on vacation ;).
> Getting CCd on revisions and -mm inclusion is a really nice reminder.
> 
> Unless there is a really good reason not to (is there ever?), could
> you please keep CCs?
> 

Ok, if you want, I'll CC always.
I myself just don't like to get 3 copies of mails when I don't have
much interests ;)

Thanks,
-Kame

