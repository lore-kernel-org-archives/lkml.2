Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KJBBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:01:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33992 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KJBBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QxPCuD5qrOpXkRtfMVTCAGIrm2x6+Pll+P3v9KEOCgceun38c6ZCt5LMmRJXFWqEIq
         13x+0y+soEjK1F7fiwvfVnYLev0WYBqoyr0lraraE7QhQYvJKEiXoPpb3gFq+2gD5jNF
         azs/oxTMIs7Ru61gBBznrphPvaUpacnRQZtd0=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-6-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-6-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 10:01:14 +0900
Message-ID: <AANLkTin9rfeipUsy1GaT1suP+ivES-cK5U2o26i4hCtE@mail.gmail.com>
Subject: Re: [PATCH 5/6] memcg: simplify mem_cgroup_dirty_info()
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> Because mem_cgroup_page_stat() no longer returns negative numbers

I tried to understand why mem_cgroup_page_stat doesn't return negative
number any more for a while.
I couldn't find answer by current patches 5/6.
The answer is where 6/6.
It would be better to change 6/6 with 5/6.


> to indicate failure, mem_cgroup_dirty_info() does not need to check
> for such failures.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
