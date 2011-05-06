Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1EFTDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:03:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab1EFTDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:03:40 -0400
Message-ID: <4DC445C3.2050102@redhat.com>
Date: Fri, 06 May 2011 15:02:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/17] writeback: sync expired inodes first in background
 writeback
References: <20110506030821.523093711@intel.com> <20110506031612.539339712@intel.com>
In-Reply-To: <20110506031612.539339712@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 11:08 PM, Wu Fengguang wrote:
> A background flush work may run for ever. So it's reasonable for it to
> mimic the kupdate behavior of syncing old/expired inodes first.
>
> At each queue_io() time, first try enqueuing only newly expired inodes.
> If there are zero expired inodes to work with, then relax the rule and
> enqueue all dirty inodes.
>
> CC: Dave Chinner<david@fromorbit.com>
> CC: Jan Kara<jack@suse.cz>
> CC: Rik van Riel<riel@redhat.com>
> Acked-by: Mel Gorman<mel@csn.ul.ie>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
