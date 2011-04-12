Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1DLHEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:04:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab1DLHEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sK9O4b6Us2FJNVisls87x4CtbQBMntXD3x4OrxSQa/CS9Zi+qrOIcytjd5dA+7wMOk
         6g1//Lp9eeWk0MQzhjgNM9w/cZFcazPkCU5+cQFTDkqV+toLBKB5WlqU4OA8/0o7dhu3
         0pG7lRXFx8NELyPc66a7aINQHa+35jxADA5VE=
MIME-Version: 1.0
In-Reply-To: <20110411170103.035A.A69D9226@jp.fujitsu.com>
References: <20110411165957.0352.A69D9226@jp.fujitsu.com>
	<20110411170103.035A.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 16:03:59 +0900
Message-ID: <BANLkTinvANUNE2CVcDCbkR+xNq0bq0RZCQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm, mem-hotplug: recalculate lowmem_reserve when
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

On Mon, Apr 11, 2011 at 5:00 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Currently, memory hotplug call setup_per_zone_wmarks() and
> calculate_zone_inactive_ratio(), but don't call setup_per_zone_lowmem_reserve().
>
> It mean number of reserved pages aren't updated even if memory hot plug
> occur. This patch fixes it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
