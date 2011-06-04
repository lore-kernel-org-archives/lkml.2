Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1FDJyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 05:54:32 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:65088 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1FDJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 05:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vqGhaSpa/8EyNeA1qt1TwgaaIFZJ3l8EG/1jvzAngRjjXRTgr471i2DguOaaFqm5p6
         vJwNfVE/SlsmQHNYcav5ZzXqbKPV+R7oH7pt5NeKtsTWA3cKTGM8bAmpsdm2pYiTg5RF
         KeQ8WkMDrBWFoK/NArxH86ZOAhnoQ0mXk3vSQ=
Date: Sat, 4 Jun 2011 18:54:17 +0900
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
Subject: Re: [PATCH v8 01/12] memcg: document cgroup dirty memory interfaces
Message-ID: <20110604095417.GA4731@barrios-laptop>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-2-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307117538-14317-2-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:12:07AM -0700, Greg Thelen wrote:
> Document cgroup dirty memory interfaces and statistics.
> 
> The implementation for these new interfaces routines comes in a series
> of following patches.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards
Minchan Kim
