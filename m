Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2ITHeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:34:46 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50540 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ITHep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:34:45 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-e9-505ac70d69a2
Date: Thu, 20 Sep 2012 16:37:19 +0900
From: Minchan Kim <minchan@kernel.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] memory-hotplug: fix zone stat mismatch
Message-ID: <20120920073719.GH13234@bbox>
References: <1348123405-30641-1-git-send-email-minchan@kernel.org>
 <505AC3E9.4030009@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505AC3E9.4030009@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yasuaki,

On Thu, Sep 20, 2012 at 04:21:13PM +0900, Yasuaki Ishimatsu wrote:
> Hi Minchan,
> 
> Sorry for late reply.
> 
> 2012/09/20 15:43, Minchan Kim wrote:
> > During memory-hotplug, I found NR_ISOLATED_[ANON|FILE]
> > are increasing so that kernel are hang out.
> 
> Why does your system hang out by increasing NR_ISOLATED_[ANON|FILE]?
> I cannot understand what has happened by your system.

If system doesn't have enough free page, it goes reclaim path and never
reclaim any pages by too_many_isolated and loop forever.

--
Kind regards,
Minchan Kim
