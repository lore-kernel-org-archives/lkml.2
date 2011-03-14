Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1CNO41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:56:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62988 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1CNO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xtPM0kp1r+bHG4fbzmY545bXaoH5DLnsyh5qa/BYOzbFcotfuFJwXF7YgpnVgnboZh
         LBWpfr2b+cJbF3XUJwM0Re747jAhvoB46nqs8XxOTNXxvMlvCsGj8kXQgwZwb6Pj+nhF
         lfwxybU4GIM24UNbt8sGTd1a8bsItXdXF86zI=
Date: Mon, 14 Mar 2011 23:56:01 +0900
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
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 3/9] memcg: add dirty page accounting infrastructure
Message-ID: <20110314145601.GE11699@barrios-desktop>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <1299869011-26152-4-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299869011-26152-4-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:43:25AM -0800, Greg Thelen wrote:
> Add memcg routines to track dirty, writeback, and unstable_NFS pages.
> These routines are not yet used by the kernel to count such pages.
> A later change adds kernel calls to these new routines.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
