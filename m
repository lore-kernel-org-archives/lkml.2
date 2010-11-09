Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0KIXJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:09:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51323 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0KIXJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y3WNsMgaaRZGd1yNtj4CqihuamGpfzA2T+CurHrKFYZq2ZafuYur19R5FwXy9j18i+
         InyJbkXZFgafEyQy6R8qJPOtRvia63gitkEImQ1Zm6ZTsifOmJ61bcdGDYKo9/c7TwOl
         fCJDZAIRWqIrWm2ytkszSWbrWsLGh/IBa/jZg=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-3-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-3-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 08:09:06 +0900
Message-ID: <AANLkTi=Nd6qy5S0zLUN80iEhQab3rGK77waVihEhN4ia@mail.gmail.com>
Subject: Re: [PATCH 2/6] memcg: pass mem_cgroup to mem_cgroup_dirty_info()
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> Pass mem_cgroup parameter through memcg_dirty_info() into
> mem_cgroup_dirty_info().  This allows for querying dirty memory
> information from a particular cgroup, rather than just the
> current task's cgroup.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
