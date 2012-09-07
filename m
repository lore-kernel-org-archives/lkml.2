Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab2IGJRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:17:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2IGJRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:17:06 -0400
Date: Fri, 7 Sep 2012 10:17:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v3 0/4] memory-hotplug: handle page race between
 allocation and isolation
Message-ID: <20120907091701.GW11266@suse.de>
References: <1346978372-17903-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1346978372-17903-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:39:28AM +0900, Minchan Kim wrote:
> Memory hotplug has a subtle race problem so this patchset fixes the problem
> (Look at [3/3] for detail and please confirm the problem before review
> other patches in this series.)
> 
>  [1/4] is just clean up and help for [2/4].
>  [2/4] keeps the migratetype information to freed page's index field
>        and [3/4] uses the information.
>  [3/4] fixes the race problem with [2/4]'s information.
>  [4/4] enhance memory-hotremove operation success ratio
> 
> After applying [2/4], migratetype argument in __free_one_page
> and free_one_page is redundant so we can remove it but I decide
> to not touch them because it increases code size about 50 byte.
> 
> This patchset is based on mmotm-2012-09-06-16-46
> 

Nothing jumped out and poked me in the eye so for the series;

Acked-by: Mel Gorman <mgorman@suse.de>

Thanks!

-- 
Mel Gorman
SUSE Labs
