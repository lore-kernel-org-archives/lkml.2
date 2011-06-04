Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1FDP5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:57:43 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43474 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab1FDP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b1Gkc9nUg5gak5lBvtn+t1p7oXgZbIh4QqpVjut380UQ1hmV8wuidReSwlP/N7zuCx
         lHCBoihLwnw32E8wiT5FK/PPeAlIRvPUGWd1tp3R3SQQ6mp9Lt1NZMmH83LcWUoV0yjl
         PP0M2TD67sHA7aEHbnXBkPg3J1EAjp7ZKLyz8=
Date: Sun, 5 Jun 2011 00:57:31 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 06/12] memcg: add dirty limits to mem_cgroup
Message-ID: <20110604155731.GB1445@barrios-laptop>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-7-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307117538-14317-7-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:12:12AM -0700, Greg Thelen wrote:
> Extend mem_cgroup to contain dirty page limits.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com> 

-- 
Kind regards
Minchan Kim
