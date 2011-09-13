Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1IMKcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:32:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41103 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1IMKcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:32:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Sep 2011 19:31:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11] mm: move memcg hierarchy reclaim to generic
 reclaim code
Message-Id: <20110913193115.6098c87a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315825048-3437-6-git-send-email-jweiner@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-6-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 12:57:22 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Memory cgroup limit reclaim and traditional global pressure reclaim
> will soon share the same code to reclaim from a hierarchical tree of
> memory cgroups.
> 
> In preparation of this, move the two right next to each other in
> shrink_zone().
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

ok, this will be good direction.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

