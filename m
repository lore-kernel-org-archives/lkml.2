Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0JRFXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:23:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62387 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0JRFXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s+t8VppOGb89mWzZhHrq/yxV4aciLA5Cy2hIyKvn2nbhlR327+UeZbmfv+9iHbtQqQ
         qjE8Vnq+T3rh/I7SJExqgRP9jdE1DMSEvxZ9jbDc1A4luLEN2CNMhrAWQEobw1xR6lfb
         ocZbDSYfxWopnbybU8mdFFrOz2/fBWj5b3Y4E=
MIME-Version: 1.0
In-Reply-To: <4CB8725B.9010200@kernel.org>
References: <4CB8725B.9010200@kernel.org>
Date: Mon, 18 Oct 2010 14:23:40 +0900
Message-ID: <AANLkTinkiQ9vVB=EBGkKOwLktR9fvzZY2dS1rKKF_tRE@mail.gmail.com>
Subject: Re: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to flush_scheduled_work()
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:25 AM, Tejun Heo <tj@kernel.org> wrote:
> lru_add_drain_all() uses schedule_on_each_cpu() which is synchronous.
> There is no reason to call flush_scheduled_work() after
> lru_add_drain_all().  Drop the spurious calls.
>
> This is to prepare for the deprecation and removal of
> flush_scheduled_work().
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
