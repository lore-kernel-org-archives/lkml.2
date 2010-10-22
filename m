Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0JVMBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0JVMBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:01:24 -0400
Message-ID: <4CC17CF1.4000109@redhat.com>
Date: Fri, 22 Oct 2010 08:00:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH] mm: Avoid possible deadlock caused by too_many_isolated()
References: <20101022045509.GA16804@localhost>
In-Reply-To: <20101022045509.GA16804@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 12:55 AM, Wu Fengguang wrote:

> Now !GFP_IOFS reclaims won't be waiting for GFP_IOFS reclaims to
> progress. They will be blocked only when there are too many concurrent
> !GFP_IOFS reclaims, however that's very unlikely because the IO-less
> direct reclaims is able to progress much more faster, and they won't
> deadlock each other. The threshold is raised high enough for them, so
> that there can be sufficient parallel progress of !GFP_IOFS reclaims.
>
> CC: Torsten Kaiser<just.for.lkml@googlemail.com>
> CC: Minchan Kim<minchan.kim@gmail.com>
> Tested-by: NeilBrown<neilb@suse.de>
> Acked-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
