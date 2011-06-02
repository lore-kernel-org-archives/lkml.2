Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1FBO31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:29:27 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:40848 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1FBO30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:29:26 -0400
Date: Thu, 2 Jun 2011 16:28:57 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] vmscan: change zone_nr_lru_pages to take memcg
 instead of scan control
Message-ID: <20110602142857.GD28684@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-7-git-send-email-hannes@cmpxchg.org>
 <BANLkTi=x_Fm-AcwcRAicJ4BaK1z0tT0u+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=x_Fm-AcwcRAicJ4BaK1z0tT0u+Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 10:30:48PM +0900, Hiroyuki Kamezawa wrote:
> 2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
> > This function only uses sc->mem_cgroup from the scan control.  Change
> > it to take a memcg argument directly, so callsites without an actual
> > reclaim context can use it as well.
> >
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I wonder this can be cut out and cab be merged immediately, no ?

I don't see anything standing in the way of that.  OTOH, all current
users have scan controls, so it's not really urgent, either.

