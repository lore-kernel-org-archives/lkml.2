Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1BJCgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:36:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36240 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1BJCgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PYF6QkY7HgrPfDyLfsnQcnvjCD6Q8idgOB3GmP2YyYFyILcSEW7FehmyCGQdc72Ooa
         QesVvlPWgfqLjLWeV3Frtd7Dhe5XfLi8UhxP95CjfxmqX0hDor2Lt+Zi5JkqiKTVX5qJ
         +8TVkNKlhJ9L/RC6vPQ9NEPB4nlp/PBs9OP8I=
MIME-Version: 1.0
In-Reply-To: <1297248275-23521-1-git-send-email-hannes@cmpxchg.org>
References: <1297248275-23521-1-git-send-email-hannes@cmpxchg.org>
Date: Thu, 10 Feb 2011 11:36:02 +0900
Message-ID: <AANLkTimJcJaUWSuJYu-u7n2Ep1JWLC08XO0NECriX67A@mail.gmail.com>
Subject: Re: [patch] memcg: charged pages always have valid per-memcg zone info
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 7:44 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> page_cgroup_zoneinfo() will never return NULL for a charged page,
> remove the check for it in mem_cgroup_get_reclaim_stat_from_page().
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
