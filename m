Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1FDJ4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 05:56:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46832 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab1FDJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 05:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TAlvtAOyvJuL2l31KPBve6ts3p1/wX0P4XbXx0xeuX7gFaFVNVcRbKEO47OPUhMMhB
         tQRK2/zcsvh11aQoQzScp4WvTCY9aqAyXBCOMcYKW/lNMNAWsuISQn9D2HjOYxtNdaGH
         lmhpoV5x8RjLsl+EV4klcZeN46HREUcDp1oWU=
Date: Sat, 4 Jun 2011 18:56:28 +0900
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
Subject: Re: [PATCH v8 02/12] memcg: add page_cgroup flags for dirty page
 tracking
Message-ID: <20110604095628.GB4731@barrios-laptop>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-3-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307117538-14317-3-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:12:08AM -0700, Greg Thelen wrote:
> Add additional flags to page_cgroup to track dirty pages
> within a mem_cgroup.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards
Minchan Kim
