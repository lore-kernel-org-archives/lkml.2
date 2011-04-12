Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1DLJYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:24:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63406 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1DLJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=urzmTKVqHnpZCwsZzKCK0S/MAZ9qWkcJkOcz/wQLydoP2epmwRwUyPc9nhvhfODkVI
         hQBhBp3InpetA66AF72+sKcjuYsi0GPX6iVcfOd50lBIHge5YFMnaAPqlheucoZXIzRl
         P+5KmcKK6C2PRieKpm9YM2rrRtg4LtVvFUZSQ=
MIME-Version: 1.0
In-Reply-To: <20110411170134.035E.A69D9226@jp.fujitsu.com>
References: <20110411165957.0352.A69D9226@jp.fujitsu.com>
	<20110411170134.035E.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 18:24:08 +0900
Message-ID: <BANLkTi=fEejkrPdX27bFi1x+dHpOSGxQaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm, mem-hotplug: update pcp->stat_threshold when
 memory hotplug occur
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, KOSAKI

On Mon, Apr 11, 2011 at 5:01 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Currently, cpu hotplug updates pcp->stat_threashold, but memory
> hotplug doesn't. there is no reason.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Christoph Lameter <cl@linux.com>

I can think it makes sense so I don't oppose the patch merging.
But as you know I am very keen on the description.

What is the problem if hotplug doesn't do it?
I means the patch solves what's problem?

Please write down fully for better description.
Thanks.

-- 
Kind regards,
Minchan Kim
