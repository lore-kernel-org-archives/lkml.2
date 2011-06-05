Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1FEExJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 00:53:09 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54270 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1FEExH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 00:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oPouRP2SvWeYSAy/tIjNYOdS76wF/bwZVZzDrl6CXVJwi6TRrPJxwpv99z+NoTmVO0
         ews3HQCPkKkD5S1NA7krVx5XI4qUe/q+w9xkuWpIbhcUzd6ZcNkAnFdCcmNPCH6ECHP/
         HAxviHECsv2Oy/AXp9QvxhCDxsXlVIg1H8TsU=
Date: Sun, 5 Jun 2011 13:52:55 +0900
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
Subject: Re: [PATCH v8 12/12] memcg: check memcg dirty limits in page
 writeback
Message-ID: <20110605045255.GD5914@barrios-laptop>
References: <1307117797-747-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307117797-747-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:16:37AM -0700, Greg Thelen wrote:
> If the current process is in a non-root memcg, then
> balance_dirty_pages() will consider the memcg dirty limits as well as
> the system-wide limits.  This allows different cgroups to have distinct
> dirty limits which trigger direct and background writeback at different
> levels.
> 
> If called with a mem_cgroup, then throttle_vm_writeout() queries the
> given cgroup for its dirty memory usage limits.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards
Minchan Kim
