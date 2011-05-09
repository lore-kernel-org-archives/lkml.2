Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1EIQTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1EIQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:19:38 -0400
Message-ID: <4DC813CB.2040103@redhat.com>
Date: Mon, 09 May 2011 12:18:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/17] writeback: sync expired inodes first in background
 writeback
References: <20110506030821.523093711@intel.com> <20110506031612.539339712@intel.com> <20110509160827.GS4122@quack.suse.cz>
In-Reply-To: <20110509160827.GS4122@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 12:08 PM, Jan Kara wrote:

>    The age of pages in LRU is not necessarily related with the
> i_dirtied_when time stamp so I'm not sure how much this will help after all

Not necessarily, but given that the inactive file list is a
FIFO list, I expect there will be decent correlation.

> but it makes some sense from the data integrity point of view at least. You
> can add:
> Acked-by: Jan Kara<jack@suse.cz>

Good point on the data integrity.

-- 
All rights reversed
