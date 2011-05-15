Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1EOTxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 15:53:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1EOTxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 15:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=arTWgJiFpv3ayNpYSnD6wOCeoENKN48humZiAiAYkiBblBXcvbbvRWTCE/ypHR6fJL
         KwZpNJn5pUCViU9MInvg==
MIME-Version: 1.0
In-Reply-To: <20110513185152.56c41483.kamezawa.hiroyu@jp.fujitsu.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
 <1305276473-14780-10-git-send-email-gthelen@google.com> <20110513185152.56c41483.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Sun, 15 May 2011 12:53:19 -0700
Message-ID: <BANLkTi=0_H_6a0yrpbnnqJJ-_aWv8suqfQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v7 09/14] cgroup: move CSS_ID_MAX to cgroup.h
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 2:51 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 13 May 2011 01:47:48 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> This allows users of css_id() to know the largest possible css_id value.
>> This knowledge can be used to build per-cgroup bitmaps.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Hmm, I think this can be merged to following bitmap patch.

Ok.  I will merge this in following patch.
